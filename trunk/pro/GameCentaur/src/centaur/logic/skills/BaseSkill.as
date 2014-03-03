package centaur.logic.skills
{
	import centaur.data.card.CardData;
	import centaur.data.card.CardEnumDefines;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillDataList;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.buff.BaseBuff;
	import centaur.logic.combat.CombatLogic;
	import centaur.utils.Utils;
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * 技能基类 
	 * @author minnie
	 * 
	 */	
	public class BaseSkill
	{	
		/**
		 * 技能ID 
		 */		
		protected var _skillID:int;
		
		/**
		 * 技能类型 
		 */		
		private var _skillType:int;
		
		/**
		 * 法术类型 
		 */		
		private var _magicType:int;
		
		/**
		 * 技能攻击目标类型 
		 */		
		private var _selectTargetType:int;
		
		/**
		 * 技能级别
		 */		
		private var _skillLevel:int;
		
		/**
		 * 技能触发优先级 
		 */		
		protected var _priority:int;
		
		/**
		 * BuffID 
		 */		
		protected var _buffID:int;
		
		/**
		 * 技能名称 
		 */		
		protected var _skillName:String;
		
		/**
		 * 技能所有者 
		 */	
		public var card:BaseCardObj;
		
		
		public function get skillID():int
		{
			return _skillID;
		}
		
		public function get skillType():int
		{
			return _skillType;
		}
		
		public function get magicType():int
		{
			return _magicType;
		}
		
		public function get skillLevel():int
		{
			return _skillLevel;
		}
		
		public function get buffID():int
		{
			return _buffID;
		}
		public function set buffID(id:int):void
		{
			_buffID = id;
		}
		public function get skillName():String
		{
			return _skillName;
		}
		
		public function BaseSkill(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			SetCardData(skillPara);
			
			if (data != null)
				initConfig(data);
			
			if (card != null)
				registerCard(card);
		}
		
		
		/**
		 * 根据ID获取技能对象 
		 * @param id
		 * @return 
		 * 
		 */		
		public static function getSkillByID(card:BaseCardObj, skillID:int, skillPara:Array):BaseSkill
		{
			var data:SkillData = SkillDataList.getSkillData(skillID);
			var skillName:String = "centaur.logic.skills.Skill_" + data.templateID.toString();
			var skill:Class= getDefinitionByName(skillName) as Class;
			if (skill != null)	
				return new skill(data, card, skillPara);
			
			return null;
		}
		
		/**
		 * 设置卡牌自带的技能参数,默认为技能级别 
		 * @param data
		 * 
		 */		
		public function SetCardData(data:Array):void
		{
			if (data == null || data.length == 0)
				return;
			
			_skillLevel = data[0];
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
			_skillType = data.skillType;
			_magicType = data.magicType;
			_skillName = data.name;
			// _skillLevel = data.skillLevel;
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
					_doSkill(targetCard);
				}
			}
		}
		
		protected function _doSkill(targetCard:BaseCardObj):void
		{
			
		}
		
		/**
		 *  获得技能的描述
		 * @return 
		 * 
		 */		
		public function getSkillDesc():String
		{
			var skillData:SkillData = null;
			skillData = SkillDataList.getSkillData(skillID);
			return skillData.discription;
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
			var cards:Array;
			var i:int = 0;
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
					idx = Math.random() * targetAct.combatData.selfCombatArea.length;
					target = targetAct.combatData.selfCombatArea[idx];
					if (!target)
						target = targetAct.combatData.getCardFromCombatArea();
					return target ? [target] : null;
					
				// 随机2个目标
				case SkillEnumDefines.TARGET_RANDOM2_TYPE:
					return targetAct.combatData.getCardFromCombatAreaRandom2();
					
				// 随机3个目标
				case SkillEnumDefines.TARGET_RANDOM3_TYPE:
					return targetAct.combatData.getCardFromCombatAreaRandom3();
					
				// 敌方所有目标
				case SkillEnumDefines.TARGET_ALL_TYPE:
					return targetAct.combatData.getAllCombatAreaCard();
				
				case SkillEnumDefines.TARGET_MAX_LOSE_HP_TYPE:
					// 失血最多的目标
					var maxLoseHPTarget:BaseCardObj = card.owner.combatData.getCardFromCombatAreaMaxLoseHP();
					return maxLoseHPTarget ? [maxLoseHPTarget] : null;
					break;
					
				// 随机一个可以治疗的目标
				case SkillEnumDefines.TARGET_RANDOM_CURE:
					cards = card.owner.combatData.getCardFromCombatAreaCanCure();
					if (cards.length == 0)
						return null;
					idx = Math.random() * card.owner.combatData.getCardFromCombatAreaCanCure().length
					target = card.owner.combatData.selfCombatArea[idx];
					return target ? [target] : null;
						
				// 所有可以治疗的目标
				case SkillEnumDefines.TARGET_ALL_CURE:
					return card.owner.combatData.getCardFromCombatAreaCanCure();
					
				// 相同国家的卡牌
				case SkillEnumDefines.TARGET_SAME_COUNTRY:
					cards = card.owner.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target != null && target.objID != card.objID && target.cardData.country == card.cardData.country)
							targets.push(target);
					}
					return targets;
				case SkillEnumDefines.TARGET_SELF_HURT_TYPE:
					if (card.isHurt)
						return [card];
					else
						return null;
					
				// 自身英雄
				case SkillEnumDefines.TARGET_MY_HERO:
					return [card.owner];
					
				// 对面英雄
				case SkillEnumDefines.TARGET_ENEMY_HERO:
					return [targetAct];
					
				// 势力1卡牌
				case SkillEnumDefines.TARGET_COUNTRY_1:
					cards = card.owner.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target != null && target != card && target.cardData.country == CardEnumDefines.CARD_COUNTRY_SHU)
							targets.push(target);
					}
					return targets;
					
				// 势力2卡牌
				case SkillEnumDefines.TARGET_COUNTRY_2:
					cards = card.owner.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target != null && target != card && target.cardData.country == CardEnumDefines.CARD_COUNTRY_WEI)
							targets.push(target);
					}
					return targets;
					
				// 势力3卡牌
				case SkillEnumDefines.TARGET_COUNTRY_3:
					cards = card.owner.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target != null && target != card && target.cardData.country == CardEnumDefines.CARD_COUNTRY_WU)
							targets.push(target);
					}
					return targets;
					
				// 势力4卡牌
				case SkillEnumDefines.TARGET_COUNTRY_4:
					cards = card.owner.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target != null && target != card && target.cardData.country == CardEnumDefines.CARD_COUNTRY_QUN)
							targets.push(target);
					}
					return targets;
					
				// 等待时间最长的卡牌
				case SkillEnumDefines.MAX_ROUND_WAIT:
					cards = targetAct.combatData.selfWaitArea;
					var maxWait:int = 0;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target != null && target.waitRound > maxWait)
						{
							maxWait = target.waitRound;
							targets[0] = target;
						}
					}
					return targets;
					
				// 随机1个没有buff的卡牌
				case SkillEnumDefines.NO_BUFF_RANDOM:
					cards = targetAct.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target && !target.hasBuff(this.buffID))
							targets.push(target);
					}
					return Utils.randomArray(targets, 1);
					
				// 随机2个没有buff的卡牌
				case SkillEnumDefines.NO_BUFF_RANDOM2:
					cards = targetAct.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target && !target.hasBuff(this.buffID))
							targets.push(target);
					}
					return Utils.randomArray(targets, 2);
					
				// 随机3个没有buff的卡牌
				case SkillEnumDefines.NO_BUFF_RANDOM3:
					cards = targetAct.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target && !target.hasBuff(this.buffID))
							targets.push(target);
					}
					return Utils.randomArray(targets, 3);
					
				// 所有没有buff的卡牌
				case SkillEnumDefines.NO_BUFF_ALL:
					cards = targetAct.combatData.selfCombatArea;
					for (i = 0; i < cards.length; i++)
					{
						target = cards[i];
						if (target && !target.hasBuff(this.buffID))
							targets.push(target);
					}
					return targets;
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