package centaur.logic.skill
{
	import centaur.data.buff.BuffData;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.logic.action.DamageNotifyAction;
	import centaur.logic.action.SkillEffectAction;

	/**
	 *   魔法技能防御基类
	 */
	public class MagicDefenseSkillHandler extends SkillHandlerBase
	{
		public function MagicDefenseSkillHandler()
		{
			super();
		}
		
		override public function doHandler(defenseSkill:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):*
		{
			var damage:int;
			var defenseCard:BaseCardObj = srcObj.target;
			var skillData:SkillData = specifics as SkillData;	// 魔法防御技能
			if (!defenseCard || !skillData)
				return;
			
			if (defenseSkill && defenseSkill.avoidMagicDamage)	// 无视魔法伤害,魔免
			{
				list.push(SkillEffectAction.addSkillEffect(srcObj.objID, defenseCard.objID, defenseSkill.templateID, null));	// 魔免效果
				return damage;
			}
			if (defenseSkill && defenseSkill.avoidMagicDamageRatio > 0 &&
				Math.random() * 100 <= defenseSkill.avoidMagicDamageRatio)	// 闪避魔法伤害判定
			{
				list.push(SkillEffectAction.addSkillEffect(srcObj.objID, defenseCard.objID, defenseSkill.templateID, null));	// 闪避效果
				return damage;
			}
			
			// 优先计算技能伤害
			damage = calcSkilledDamage(srcObj, defenseCard, skillData, defenseSkill, list);
			list.push(DamageNotifyAction.addDamageAction(damage, defenseCard.objID));	// 伤害操作
			srcObj.lastDamageValue = defenseCard.lastBeDamagedVal = damage;
			
			// 如果已经死亡，不需要判断BUFF伤害等，直接进入濒临死亡状态
			if (defenseCard.checkDead())
				return damage;
			
			// 处理反弹伤害效果,如果已死是没机会反弹的
			if (defenseSkill && defenseSkill.reflexMagicDamage > 0)
			{
				SkillLogic.doMagicSkiller(defenseSkill, defenseCard, srcObj.owner, list);
			}
			
			// 增加持续伤害或BUFF，到BUFF点结算，BUFF点一般为回合开始，回合结束等
			if (skillData.durationRound > 0)
			{
				var buffData:BuffData = new BuffData(skillData.buffType, skillData.templateID, skillData.durationRound);
				defenseCard.addBuff(buffData);
				list.push(BuffNotifyAction.addBuffAction(buffData, defenseCard.objID));
			}
			
			// 计算属性变更, 属性变更是否只是当前回合,回合结束时还得恢复？这个还不确定，下面暂时简单处理
			if (skillData.attackChange != 0 && !skillData.isAffectSelf)
			{
				defenseCard.cardData.attack += skillData.attackChange;
				defenseCard.cardData.attack = (defenseCard.cardData.attack < 0) ? 0 : defenseCard.cardData.attack;
			}
			if (skillData.hpChange != 0 && !skillData.isAffectSelf)
			{
			}
			
			// 判断是否死亡
			defenseCard.checkDead();
			return damage;
		}
		
		/**
		 *   计算受技能攻击时的伤害量
		 */ 
		private function calcSkilledDamage(srcObj:BaseCardObj, defenseCard:BaseCardObj, skillData:SkillData, defenseSkill:SkillData, list:Array):int
		{
			var damage:int;
			var skillDamage:Number = (skillData.skillType == SkillEnumDefines.SKILL_MAGIC_DEFENSE_TYPE) ? skillData.reflexMagicDamage : skillData.damage;
			if (skillDamage != 0)
			{
				// 技能伤害这块有点细节，如果当前是被攻击型技能攻击，根据技能damage和目标血量计算百分比（如果配置是百分比掉血的话）
				// 如果技能是防御型反弹技能，根据技能reflexMagicDamage和自身受的伤害计算百分比（反弹自身受伤害的百分比）
				var baseVal:int = (skillData.skillType == SkillEnumDefines.SKILL_MAGIC_DEFENSE_TYPE) ? srcObj.lastBeDamagedVal : defenseCard.cardData.hp;
				damage = (skillDamage < 1 && skillDamage > -1) ? skillDamage * baseVal : skillDamage;
				if (defenseSkill)		// 计算防御技能的伤害减少或最大伤害值
				{
					if (defenseSkill.maxDamageWhenMagic > 0)
						damage = defenseSkill.maxDamageWhenMagic;
					if (defenseSkill.reduceMagicDamage > 0)
					{
						list.push(SkillEffectAction.addSkillEffect(srcObj.objID, defenseCard.objID, defenseSkill.templateID, null));	// 减伤效果
						damage -= defenseSkill.reduceMagicDamage;
					}
				}
				
				if (0 == damage)
					damage = skillDamage > 0 ? 1 : -1;
				var newHP:int = defenseCard.cardData.hp - damage;
				if (newHP <= 0)
				{
					damage = defenseCard.cardData.hp;
					defenseCard.cardData.hp = 0;
				}
				else
					defenseCard.cardData.hp = newHP;
			}
			return damage;
		}
	}
}