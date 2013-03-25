package centaur.logic.skill
{
	import centaur.data.combat.CombatData;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.AttackEffectAction;
	import centaur.logic.action.DamageNotifyAction;
	import centaur.logic.action.SkillEffectAction;
	
	import flash.utils.Dictionary;

	/**
	 *   专门处理技能相关的逻辑
	 */ 
	public final class SkillLogic
	{
		SkillScriptRegister.register();
		
		/**
		 *   特殊技能效果的逻辑
		 */ 
		public static function doSpecSkiller(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):void
		{
			if (!skillData)
				return;
			
			var skillHandler:SkillHandlerBase = getHandler(skillData.script, skillData.skillType);
			if (!skillHandler)
				return;
			
			skillHandler.doHandler(skillData, srcObj, targetObj, list, specifics);
		}
		
		/**
		 *   特殊技能效果的防御逻辑
		 */ 
		public static function doSpecDefenser(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):Object
		{
			var skillHandler:SkillHandlerBase = getHandler(skillData ? skillData.script : "", 
				skillData ? skillData.skillType : SkillEnumDefines.SKILL_SPEC_DEFENSE_TYPE);
			if (!skillHandler)
				return null;
			
			return skillHandler.doHandler(skillData, srcObj, targetObj, list, specifics);
		}
		
		/**
		 *  技能攻击逻辑
		 */ 
		public static function doMagicSkiller(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):void
		{
			if (!skillData)
				return;
			
			var skillHandler:SkillHandlerBase = getHandler(skillData.script, skillData.skillType);
			if (!skillHandler)
				return;
			
			skillHandler.doHandler(skillData, srcObj, targetObj, list, specifics);
		}
		
		/**
		 *   被技能攻击逻辑
		 */ 
		public static function doMagicDefenser(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):Object
		{
			// 没有魔法防御技能，则选择默认的防御技能处理
			var skillHandler:SkillHandlerBase = getHandler(skillData ? skillData.script : "", 
														skillData ? skillData.skillType : SkillEnumDefines.SKILL_MAGIC_DEFENSE_TYPE);
			if (!skillHandler)
				return null;
			
			return skillHandler.doHandler(skillData, srcObj, targetObj, list, specifics);
		}
		
		/**
		 *  普通攻击逻辑
		 */ 
		public static function doAttacker(atkSkillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):Boolean
		{
			var skillHandler:SkillHandlerBase = getHandler(atkSkillData ? atkSkillData.script : "", 
				atkSkillData ? atkSkillData.skillType : SkillEnumDefines.SKILL_ATTACK_TYPE);
			if (!skillHandler)
				return false;
			
			return skillHandler.doHandler(atkSkillData, srcObj, targetObj, list, specifics);
		}
		
		/**
		 *   被普通攻击，处理防御逻辑
		 */ 
		public static function doAttackDefenser(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):Object
		{
			var skillHandler:SkillHandlerBase = getHandler(skillData ? skillData.script : "", 
				skillData ? skillData.skillType : SkillEnumDefines.SKILL_ATTACK_DEFENSE_TYPE);
			if (!skillHandler)
				return null;
			
			return skillHandler.doHandler(skillData, srcObj, targetObj, list, specifics);
		}
		
		public static function getHandler(script:String, type:int = 0):SkillHandlerBase
		{
			var handler:SkillHandlerBase = script ? SkillScriptRegister.scriptDic[script] as SkillHandlerBase : null;
			if (!handler && type > 0)
				handler = SkillScriptRegister.scriptDic[SkillEnumDefines.SKILL2STR[type]];
			return handler;
		}
		
		/**
		 *   计算技能效果时的作用目标
		 */ 
		public static function getTargetList(skillData:SkillData, srcCardObj:BaseCardObj, srcObj:BaseActObj, targetObj:BaseActObj, isNormalAttack:Boolean = false):Array
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
				case SkillEnumDefines.TARGET_ATTACKER_TYPE:
				{
					// 返回攻击我的卡牌
					return srcCardObj.attacker ? [srcCardObj.attacker] : null;
					break;
				}
			}
			
			return null;
		}
		
	}
}