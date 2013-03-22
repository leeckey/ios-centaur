package centaur.logic.combat
{
	import centaur.data.combat.CombatData;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.AttackEffectAction;
	import centaur.logic.action.DamageNotifyAction;
	import centaur.logic.action.SkillEffectAction;

	/**
	 *   专门处理技能相关的逻辑
	 */ 
	public final class SkillLogic
	{
		public function SkillLogic()
		{
		}
		
		
		public static function doDeathSkiller(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array):void
		{
		}
		
		public static function doPresentSkiller(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array):void
		{
		}
		
		/**
		 *  技能攻击逻辑
		 */ 
		public static function doSkiller(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array):void
		{
			// 没有目标，不释放技能
			var targetList:Array = getTargetList(skillData, srcObj, srcObj.owner, targetObj);
			var targetLen:int;
			if (!targetList || (targetLen = targetList.length) == 0)
				return;
			
			// 增加释放技能操作
			list.push(SkillEffectAction.addSkillEffect(srcObj.objID, 0, skillData.templateID, targetList));
			
			// 对每个目标处理被技能攻击的回调
			for (var i:int = 0; i < targetLen; ++i)
			{
				var targetCardObj:BaseCardObj = targetList[i];
				if (targetCardObj)
					targetCardObj.onSkilled(skillData, srcObj, list);
			}
		}
		
		/**
		 *   被技能攻击逻辑
		 */ 
		public static function doSkilled():Object
		{
			return null;
		}
		
		/**
		 *  普通攻击逻辑
		 */ 
		public static function doAttacker(atkSkillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array):Boolean
		{
			// 普通攻击没目标，则默认攻击血条
			var targetList:Array = getTargetList(atkSkillData, srcObj, srcObj.owner, targetObj, true);
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
		
		/**
		 *   计算技能效果时的作用目标
		 */ 
		private static function getTargetList(skillData:SkillData, srcCardObj:BaseCardObj, srcObj:BaseActObj, targetObj:BaseActObj, isNormalAttack:Boolean = false):Array
		{
			if (!srcCardObj || !srcObj || !targetObj)
				return null;

			var idx:int;
			var i:int;
			var selectTargetType:int = skillData ? skillData.selectTargetType : SkillEnumDefines.TARGET_SELF_FRONT_TYPE;
			var isAffectSelf:Boolean = skillData ? skillData.isAffectSelf : false;
			var selectObj:BaseActObj = isAffectSelf ? srcObj : targetObj;
			var selectCombatData:CombatData = selectObj.combatData;
			if (!selectCombatData)
				return null;
			
			switch(selectTargetType)
			{
				case SkillEnumDefines.TARGET_SELF_FRONT_TYPE:
				{
					// 对面目标
					idx = srcObj.combatData.selfCombatArea.indexOf(srcCardObj);
					if (idx < 0 && (!isNormalAttack))	// 技能攻击对面没目标，默认攻击第一个
						idx = 0;
					var frontTarget:BaseCardObj = targetObj.combatData.selfCombatArea[idx];
					return frontTarget ? [frontTarget] : null;
				}
				case SkillEnumDefines.TARGET_SELF_FRONT3_TYPE:
				{
					// 目标英雄相邻3卡牌，根据isAffectSelf决定是
					idx = srcObj.combatData.selfCombatArea.indexOf(srcCardObj);
					if (idx < 0)
						return null;
					
					var res:Array = [];
					var leftTarget:BaseCardObj = selectCombatData.selfCombatArea[idx - 1];
					var ftTarget:BaseCardObj = selectCombatData.selfCombatArea[idx];
					var rightTarget:BaseCardObj = selectCombatData.selfCombatArea[idx + 1];
					if (leftTarget) res.push(leftTarget);
					if (ftTarget) res.push(ftTarget);
					if (rightTarget) res.push(rightTarget);
					return res;
					
					break;
				}
				case SkillEnumDefines.TARGET_SELF_TYPE:
				{
					// 将自身作为目标
					return [srcCardObj];
					break;
				}
				case SkillEnumDefines.TARGET_RANDOM_TYPE:
				{
					// 随机一个目标
					var randomIdx:int = Math.random() * selectCombatData.selfCombatArea.length;
					var randomTarget:BaseCardObj = selectCombatData.selfCombatArea[randomIdx];
					if (!randomTarget)
						randomTarget = selectCombatData.getCardFromCombatArea();
					return randomTarget ? [randomTarget] : null;
				}
				case SkillEnumDefines.TARGET_RANDOM3_TYPE:
				{
					// 随机3个目标
					return selectCombatData.getCardFromCombatAreaRandom3();
					break;
				}
				case SkillEnumDefines.TARGET_MIN_HP_TYPE:
				{
					// 血量最少目标
					var minHPTarget:BaseCardObj = selectCombatData.getCardFromCombatAreaMinHP();
					return minHPTarget ? [minHPTarget] : null;
					break;
				}
				case SkillEnumDefines.TARGET_MAX_LOSE_HP_TYPE:
				{
					// 失血最多的目标
					var maxLoseHPTarget:BaseCardObj = selectCombatData.getCardFromCombatAreaMaxLoseHP();
					return maxLoseHPTarget ? [maxLoseHPTarget] : null;
					break;
				}
				case SkillEnumDefines.TARGET_ALL_TYPE:
				{
					// 敌方所有目标
					return selectCombatData.selfCombatArea.concat();
					break;
				}
			}
			
			return null;
		}
		
	}
}