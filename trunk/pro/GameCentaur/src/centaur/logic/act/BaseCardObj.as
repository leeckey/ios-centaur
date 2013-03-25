package centaur.logic.act
{
	import centaur.data.buff.BuffData;
	import centaur.data.card.CardData;
	import centaur.data.card.CardTemplateData;
	import centaur.data.card.CardTemplateDataList;
	import centaur.data.combat.CombatData;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillDataList;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.action.AttackEffectAction;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.logic.action.DamageNotifyAction;
	import centaur.logic.action.SkillEffectAction;
	import centaur.logic.combat.BuffLogic;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	import centaur.logic.render.BaseCardRender;
	import centaur.logic.skill.SkillLogic;
	import centaur.utils.UniqueNameFactory;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.controls.List;

	/**
	 *   卡牌数据对象
	 */ 
	public class BaseCardObj extends EventDispatcher
	{
		public var objID:uint;
		
		public var owner:BaseActObj;
		public var cardData:CardData;
		public var render:BaseCardRender;
		public var skillDic:Dictionary;
		public var buffDic:Dictionary;
		
		public var lastDamageValue:int;			// 最近一次伤害敌方的伤害值
		public var lastBeDamagedVal:int;		// 最近一次受到的伤害值
		public var attacker:BaseCardObj;		// 最近一次攻击我的卡牌
		public var target:BaseCardObj;			// 攻击目标
		
		public function BaseCardObj(data:CardData, owner:BaseActObj)
		{
			this.cardData = data;
			this.owner = owner;
			objID = UniqueNameFactory.getUniqueID(this);
			
			init();
		}
		
		protected function init():void
		{
			if (!cardData)
				return;
			
			var cardTemplateData:CardTemplateData = CardTemplateDataList.getCardData(cardData.templateID);
			if (!cardTemplateData)
				return;
			
			buffDic = new Dictionary();	
			// 对技能进行分类，方便计算查找
			skillDic = new Dictionary();
			var skillLen:int = cardTemplateData.skillList.length;
			for (var i:int = 0; i < skillLen; ++i)
			{
				var skillData:SkillData = SkillDataList.getSkillTemplateData(cardTemplateData.skillList[i]);
				if (!skillData)
					continue;
				
				var list:Array = skillDic[skillData.skillType];
				if (!list)
					list = skillDic[skillData.skillType] = [skillData];
				else if (list.indexOf(skillData) == -1)
					list.push(skillData);
			}
		}
		
		public function resetCombatData():void
		{
			if (cardData)
			{
				var templateData:CardTemplateData = CardTemplateDataList.getCardData(cardData.templateID);
				if (templateData)
				{
					cardData.hp = cardData.maxHP;
					cardData.waitRound = templateData.maxWaitRound;
				}
			}
			buffDic = new Dictionary();
		}
		
		public function get waitRound():int
		{
			return cardData ? cardData.waitRound : 0;
		}
		
		public function addBuff(buffData:BuffData):void
		{
			if (!buffData)
				return;
			
			// 同类BUFF存在，刷新持续回合数
			var buffTypeDic:Dictionary = buffDic[buffData.buffType];
			if (!buffTypeDic)
				buffTypeDic = buffDic[buffData.buffType] = new Dictionary();
			
			var buff:BuffData = buffTypeDic[buffData.skillID];
			if (!buff)
				buffTypeDic[buffData.skillID] = buffData;
			else
				buff.durationRound = buffData.durationRound;
		}
		
		/**
		 *   处于技能施法者攻击
		 */ 
		public function onSkiller(targetActObj:BaseActObj, list:Array):Boolean
		{
			// 检测自身BUFF，技能释放时触发的BUFF
			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_SKILL_START, list))
				return true;
			
			lastDamageValue = 0;
			if (!targetActObj)
				return false;
			
			var atkSkillList:Array = skillDic[SkillEnumDefines.SKILL_MAGIC_TYPE];
			var len:int = atkSkillList ? atkSkillList.length : 0;
			if (len <= 0)		// 没有需要主动释放的攻击技能，不处理
				return false;
			
			// 准备主动技能攻击，派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_MAGIC_SKILLER));
			
			for (var i:int = 0; i < len; ++i)
			{
				if (checkDead())
					return true;
				
				var skillData:SkillData = atkSkillList[i];
				SkillLogic.doMagicSkiller(skillData, this, targetActObj, list);
			}
			
			return isDead();
		}
		
		/**
		 *   处于被技能攻击者
		 */
		public function onSkilled(skillData:SkillData, srcObj:BaseCardObj, list:Array):int
		{
			lastBeDamagedVal = 0;
			var damage:int;
			if (!skillData || !srcObj || !cardData)
				return damage;
			
			// 如果被攻击前，已死亡，不处理
			if (this.isDead())
				return damage;
			
			attacker = srcObj;
			srcObj.target = this;
			
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_MAGIC_HURT));
			
			// 受技能攻击时，与自身防御技能相计算
			var defenseSkillList:Array = skillDic[SkillEnumDefines.SKILL_MAGIC_DEFENSE_TYPE];
			var len:int = defenseSkillList ? defenseSkillList.length : 0;
			var defenseSkill:SkillData = (len > 0) ? defenseSkillList[0] : null;
			damage = SkillLogic.doMagicDefenser(defenseSkill, srcObj, this.owner, list, skillData) as int;
			return damage;
		}
		
		/**
		 *   处于普通攻击者
		 */ 
		public function onAttacker(targetActObj:BaseActObj, list:Array):Boolean
		{
			// 检测自身BUFF，普通攻击时触发的BUFF
			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_ATTACK_START, list))
				return true;
			
			lastDamageValue = 0;
			if (!targetActObj)
				return false;
			
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_ATTACK_SKILLER));
			
			// 处理普通攻击
			var atkList:Array = skillDic[SkillEnumDefines.SKILL_ATTACK_TYPE];
			var len:int = atkList ? atkList.length : 0;
			var skillData:SkillData = (len > 0) ? atkList[0] : null;
			SkillLogic.doAttacker(skillData, this, targetActObj, list);
			
			return checkDead();
		}
		
		/**
		 *   处于被普通攻击者
		 */ 
		public function onAttacked(atkSkillData:SkillData, srcObj:BaseCardObj, list:Array):int
		{
			var damage:int;
			if (!srcObj)
				return damage;
			
			// 如果被攻击前，已死亡，不处理
			if (this.isDead())
				return damage;
			
			attacker = srcObj;
			srcObj.target = this;
			
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_ATTACK_HURT));
			
			var defenseSkillList:Array = skillDic[SkillEnumDefines.SKILL_ATTACK_DEFENSE_TYPE];
			var defenseSkill:SkillData = defenseSkillList ? defenseSkillList[0] : null;
			damage = SkillLogic.doAttackDefenser(defenseSkill, srcObj, this.owner, list, atkSkillData) as int;
			return damage;
		}
		
		/**
		 *   处于濒临死亡时
		 */ 
		public function onDead():void
		{
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_DEAD));
			
			var deathSkill:SkillData = skillDic[SkillEnumDefines.SKILL_DEATH_TYPE];
			if (deathSkill)
			{
				// 派发事件
				this.dispatchEvent(new CardEvent(CardEvent.ON_SPEC_SKILLER));
				
				// 死契技能处理
				SkillLogic.doSpecSkiller(deathSkill, this, this.owner.enemyActObj, CombatLogic.combatList);
			}
			
			if (owner)
				owner.cardToCemeteryArea(this, CombatLogic.combatList);
		}
		
		/**
		 *   受到死契技能时
		 */ 
		public function onDeathSkilled():void
		{
		}
		
		/**
		 *   处于出场时
		 */ 
		public function onPresent():void
		{
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_PRESENT));
			
			var presentSkill:SkillData = skillDic[SkillEnumDefines.SKILL_PRESENT_TYPE];
			if (!presentSkill)
				return;
			
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_SPEC_SKILLER));
			
			// 降临技能处理
			SkillLogic.doSpecSkiller(presentSkill, this, this.owner.enemyActObj, CombatLogic.combatList);
		}
		
		/**
		 *   受到降临技能时
		 */ 
		public function onPresented():void
		{
		}
		
		public function onSpecSkilled(specSkillData:SkillData, srcObj:BaseCardObj, list:Array):void
		{
			if (!specSkillData || !srcObj)
				return;
			
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_SPEC_HURT));
			
			var specDefenseSkillList:Array = skillDic[SkillEnumDefines.SKILL_ATTACK_DEFENSE_TYPE];
			var specDefenseSkill:SkillData = specDefenseSkillList ? specDefenseSkillList[0] : null;
		}
		
		/**
		 *   自身回合开始
		 */ 
		public function onRoundStart():Boolean
		{
			// 检测自身BUFF，回合开始时触发的BUFF
			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_ROUND_START, CombatLogic.combatList))
				return true;
			
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_ROUND_START));
			
			return isDead();
		}
		
		/**
		 *   自身回合结束
		 */ 
		public function onRoundEnd():Boolean
		{
			// 检测自身BUFF，回合结束时触发的BUFF
			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_ROUND_END, CombatLogic.combatList))
				return true;
			
			// 派发事件
			this.dispatchEvent(new CardEvent(CardEvent.ON_ROUND_END));
			
			return isDead();
		}
		
		public function isDead():Boolean
		{
			return cardData ? (cardData.hp <= 0) : false;
		}
		
		public function checkDead():Boolean
		{
			if (cardData.hp <= 0)
			{
				this.onDead();
				return true;
			}
			
			return false;
		}
	}
}