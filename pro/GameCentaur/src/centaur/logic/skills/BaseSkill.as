package centaur.logic.skills
{
	import centaur.data.card.CardData;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.buff.BaseBuff;
	import centaur.logic.combat.CombatLogic;

	/**
	 * 技能基类 
	 * @author minnie
	 * 
	 */	
	public class BaseSkill
	{	
		/**
		 * 技能攻击目标类型 
		 */		
		public var _selectTargetType:int;
		
		/**
		 * 技能ID 
		 */		
		protected var _skillID:int;
		
		/**
		 * 技能触发优先级 
		 */		
		protected var _priority:int;
		
		/**
		 * 技能所有者 
		 */	
		public var card:BaseCardObj;
		
		/**
		 * 技能buff
		 */		
		public var buff:Class;
		
		
		public function get skillID():int
		{
			return _skillID;
		}
		
		public function BaseSkill(data:SkillData, card:BaseCardObj)
		{
			if (data != null)
				initConfig(data);
			
			if (card != null)
				registerCard(card);
		}
		
		/**
		 * 初始化技能参数,这里设置一些公共的参数
		 * @return 
		 * 
		 */		
		public function initConfig(data:SkillData):void
		{
			_skillID = data.id;
			_priority = data.priority;
			_selectTargetType = data.selectTargetType;
		}
		
		/**
		 * 注册卡牌
		 * @param card
		 * 
		 */		
		public function registerCard(card:BaseCardObj):void
		{
			this.card = card;
		}
		
		/**
		 * 取消注册卡牌 
		 * @param card
		 * 
		 */		
		public function removeCard():void
		{
			this.card = null;
		}
		
		/**
		 * 释放主动技能 
		 * 
		 */		
		public function doSkill():void
		{
			if (!card || card.isDead)
				return;
			
			var target:Array = getTarget();
			if (target == null || target.length == 0)
				return;
			
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, makeIDArray(target)));
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			
			var targetCard:BaseCardObj;
			for (var i:int = 0; i < target.length; i++)
			{
				targetCard = target[i] as BaseCardObj;
				if (targetCard != null)
				{
					targetCard = target[i] as BaseCardObj;
					_doSkill(targetCard);
				}
			}
		}
		
		protected function _doSkill(targetCard:BaseCardObj):void
		{
	
		}
		
		/**
		 * 返回卡牌对象ID组成的Array 
		 * @param target
		 * @return 
		 * 
		 */		
		public function makeIDArray(target:Array):Array
		{
			var result:Array = [];
			
			for (var i:int = 0; i < target.length; i++)
			{
				var card:BaseCardObj = target[i] as BaseCardObj;
				if (card != null)
					result.push(card.objID);
			}
			
			return result;
		}
		
		/**
		 * 获得技能释放的目标 
		 * @return 
		 * 
		 */		
		public function getTarget():Array
		{
			if (!card || !card.owner)
				return null;

			var idx:int;
			var target:BaseCardObj;
			var targets:Array = [];
			var targetAct:BaseActObj = card.owner.enemyActObj;
			switch(_selectTargetType)
			{
				// 攻击正对面的卡牌
				case SkillEnumDefines.TARGET_SELF_FRONT_TYPE:
				default:
					idx = card.owner.combatData.selfCombatArea.indexOf(card);
					if (idx < 0)
						return null;
					target = targetAct.combatData.selfCombatArea[idx];
					return target ? [target] : null;
					
				// 对自己释放
				case SkillEnumDefines.TARGET_SELF_TYPE:
					return [card];
					
				// 目标英雄相邻3卡牌，根据isAffectSelf决定是
				case SkillEnumDefines.TARGET_SELF_FRONT3_TYPE:
					idx = card.owner.combatData.selfCombatArea.indexOf(card);
					if (idx < 0)
						return null;
					
					var ftTarget:BaseCardObj = targetAct.combatData.selfCombatArea[idx];
					if (!ftTarget)
						return null;
					
					targets.push(ftTarget);
					var leftTarget:BaseCardObj = targetAct.combatData.selfCombatArea[idx - 1];
					if (leftTarget) targets.push(leftTarget);
					var rightTarget:BaseCardObj = targetAct.combatData.selfCombatArea[idx + 1];
					if (rightTarget) targets.push(rightTarget);
					return targets;
					
				// HP最低的卡牌
				case SkillEnumDefines.TARGET_MIN_HP_TYPE:
					target = targetAct.combatData.getCardFromCombatAreaMinHP();
					return target ? [target] : null;
					
				// 随机一个目标
				case SkillEnumDefines.TARGET_RANDOM_TYPE:
					var randomIdx:int = Math.random() * targetAct.combatData.selfCombatArea.length;
					var randomTarget:BaseCardObj = targetAct.combatData.selfCombatArea[randomIdx];
					if (!randomTarget)
						randomTarget = targetAct.combatData.getCardFromCombatArea();
					return randomTarget ? [randomTarget] : null;
					
				// 随机3个目标
				case SkillEnumDefines.TARGET_RANDOM3_TYPE:
					return targetAct.combatData.getCardFromCombatAreaRandom3();
					
				// 敌方所有目标
				case SkillEnumDefines.TARGET_ALL_TYPE:
					return targetAct.combatData.selfCombatArea.concat();
			}
			
			return null;
		}
		
/*		switch(selectTargetType)
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
				//return srcCardObj.attacker ? [srcCardObj.attacker] : null;
				break;
			}
		}*/
	}
}