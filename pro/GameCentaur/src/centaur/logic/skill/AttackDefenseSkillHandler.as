package centaur.logic.skill
{
	import centaur.data.buff.BuffData;
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.logic.action.DamageNotifyAction;

	/**
	 *   物理技能防御基类
	 */ 
	public class AttackDefenseSkillHandler extends SkillHandlerBase
	{
		public function AttackDefenseSkillHandler()
		{
			super();
		}
		
		override public function doHandler(defenseSkill:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):*
		{
			var damage:int;
			var defenseCard:BaseCardObj = srcObj.target;
			var atkSkillData:SkillData = specifics as SkillData;	// 物理防御技能
			if (!defenseCard || !atkSkillData)
				return;
			
			if (defenseSkill && defenseSkill.avoidAttackDamage)		// 物理免疫
			{
				return damage;
			}
			if (defenseSkill && defenseSkill.avoidAttackDamageRatio > 0 && 
				100 * Math.random() <= defenseSkill.avoidAttackDamageRatio)	// 物理闪避		
			{
				return damage;
			}
			
			damage = calcAttackedDamage(srcObj, defenseCard, atkSkillData, defenseSkill, list);	
			list.push(DamageNotifyAction.addDamageAction(damage, defenseCard.objID));	// 伤害操作
			srcObj.lastDamageValue = defenseCard.lastBeDamagedVal = damage;
			
			// 如果已经死亡，不需要判断BUFF伤害等，直接进入濒临死亡状态
			if (defenseCard.checkDead())
				return damage;
			
			// 反弹物理伤害
			
			// 增加持续伤害或BUFF，到BUFF点结算，BUFF点一般为回合开始，回合结束等
			if (atkSkillData && atkSkillData.durationRound > 0)
			{
				var buffData:BuffData = new BuffData(atkSkillData.buffType, atkSkillData.templateID, atkSkillData.durationRound);
				defenseCard.addBuff(buffData);
				list.push(BuffNotifyAction.addBuffAction(buffData, defenseCard.objID));
			}
			
			// 计算属性变更, 属性变更是否只是当前回合,回合结束时还得恢复？这个还不确定，下面暂时简单处理
			if (atkSkillData && atkSkillData.attackChange != 0 && !atkSkillData.isAffectSelf)
			{
				defenseCard.cardData.attack += atkSkillData.attackChange;
				defenseCard.cardData.attack = (defenseCard.cardData.attack < 0) ? 0 : defenseCard.cardData.attack;
			}
			if (atkSkillData && atkSkillData.hpChange != 0 && !atkSkillData.isAffectSelf)
			{
			}
			
			// 判断是否死亡
			defenseCard.checkDead();
			return damage;
			
			return null;
		}
		
		private function calcAttackedDamage(srcObj:BaseCardObj, defenseCard:BaseCardObj, atkSkillData:SkillData, defenseSkill:SkillData, list:Array):int
		{
			var damage:int = srcObj.cardData.attack;
			if (atkSkillData && atkSkillData.damage)
			{
				damage += atkSkillData.damage;
			}
			
			if (defenseSkill && defenseSkill.maxDamageWhenAttack > 0)
				damage = defenseSkill.maxDamageWhenAttack;
			if (defenseSkill && defenseSkill.reduceAttackDamage > 0)
				damage -= defenseSkill.reduceAttackDamage;
			if (damage <= 0)	// 默认至少攻击1点血吧
				damage = 1;
			var newHP:int = defenseCard.cardData.hp - damage;
			if (newHP <= 0)
			{
				damage = defenseCard.cardData.hp;
				defenseCard.cardData.hp = 0;
			}
			else
				defenseCard.cardData.hp = newHP;
			
			return damage;
		}
	}
}