package centaur.logic.skill
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.AttackEffectAction;
	import centaur.logic.action.DamageNotifyAction;

	/**
	 *   物理技能攻击基类
	 */ 
	public class AttackSkillHandler extends SkillHandlerBase
	{
		public function AttackSkillHandler()
		{
			super();
		}
		
		override public function doHandler(atkSkillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):*
		{
			// 普通攻击没目标，则默认攻击血条
			var targetList:Array = SkillLogic.getTargetList(atkSkillData, srcObj, srcObj.owner, targetObj, true);
			var targetLen:int;
			if (!targetList || (targetLen = targetList.length) == 0)
			{
				// 攻击血槽
				var damage:int = (targetObj.actData.hp < srcObj.cardData.attack) ? targetObj.actData.hp : srcObj.cardData.attack;
				targetObj.actData.hp -= damage;
				
				// 增加攻击操作
				list.push(AttackEffectAction.addAttackEffect(srcObj.objID, targetObj.objID));
				list.push(DamageNotifyAction.addDamageAction(damage, targetObj.objID));
				
				// 如果击杀目标，直接结束战斗，则增加相应操作
				if (targetObj.actData.hp <= 0)
				{
					targetObj.actData.hp = 0;
					return true;	// 表示已分出胜负
				}
			}
			else
			{
				// 自身属性变更
				if (atkSkillData && atkSkillData.isAffectSelf)
				{
					if (atkSkillData.attackChange > 0)
						srcObj.cardData.attack += atkSkillData.attackChange;
					if (atkSkillData.hpChange > 0)
						srcObj.cardData.hp += atkSkillData.hpChange;
				}
				
				list.push(AttackEffectAction.addAttackEffect(srcObj.objID, 0, targetList, atkSkillData ? atkSkillData.templateID : 0));
				
				// 处理被攻击回调
				for (var i:int = 0; i < targetLen; ++i)
				{
					var targetCardObj:BaseCardObj = targetList[i];
					if (targetCardObj)
						targetCardObj.onAttacked(atkSkillData, srcObj, list);
				}
				
				// 处理攻击完后的吸血
				if (atkSkillData && atkSkillData.vampireRatio > 0)
				{
					//					list.push(AttackEff
				}
				
				// 恢复自身属性
				if (atkSkillData && atkSkillData.isAffectSelf && (!srcObj.isDead()))
				{
					if (atkSkillData.attackChange > 0)
						srcObj.cardData.attack -= atkSkillData.attackChange;
				}
			}
			
			return false;
		}
	}
}