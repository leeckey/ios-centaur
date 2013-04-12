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
	import centaur.logic.action.*;
	import centaur.logic.combat.BuffLogic;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	import centaur.logic.render.BaseCardRender;
	import centaur.logic.skills.*;
	import centaur.utils.UniqueNameFactory;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	

	/**
	 *   卡牌数据对象
	 */ 
	public class BaseCardObj extends EventDispatcher
	{
		public static const SKIN_HEAD_TYPE:int = 0;
		public static const SKIN_NORMAL_TYPE:int = 1;
		public static const SKIN_DETAILS_TYPE:int = 2;
		public static const SKIN_HEAD_DEAD_TYPE:int = 3;
		
		public var objID:uint;
		
		public var owner:BaseActObj;          // 卡牌所有者
		public var cardData:CardData;         // 卡牌初始化数据
		public var render:BaseCardRender;     // 卡牌显示控制
		public var skills:Array;              // 卡牌的技能
		public var buffDic:Dictionary;        // 卡牌Buff
		
		public var lastDamageValue:int;		// 最近一次伤害敌方的伤害值
		public var lastBeAttackVal:int;        // 最近一次受到普通攻击的攻击力
		public var lastBeDamagedVal:int;		// 最近一次受到的伤害值
		public var attacker:BaseCardObj;		// 最近一次攻击我的卡牌
		public var target:BaseCardObj;			// 攻击目标
		
		private var _attack:int;               // 卡牌的攻击力
		private var _hp:int;                   // 卡牌的血量
		public var waitRound:int;              // 冷却回合数
		public var isDead:Boolean;             // 是否已经死亡
		public var attackSkill:BaseSkill;      // 普通攻击技能
		
		public function get attack():int
		{
			return this._attack;
		}

		
		/**
		 * 只读属性,只能用ReductHP来修改 
		 * @return 
		 * 
		 */		
		public function get hp():int
		{
			return this._hp;
		}
		
		/**
		 * 增加攻击力,暂不设上限 
		 * @param num
		 * @return 
		 * 
		 */		
		public function addAttack(num:int):int
		{
			this._attack += num;
			CombatLogic.combatList.push(AttackChangeAction.getAction(objID, num));
			trace(objID + "当前攻击力为:" + attack);
			return num;
		}
		
		/**
		 * 减少攻击力 
		 * @param nun
		 * @return 
		 * 
		 */		
		public function deductAttack(num:int):int
		{
			var temp:int = this._attack;
			this._attack -= num;
			if (this._attack < 0)
				this._attack = 0;
			
			temp -= this._attack;
			CombatLogic.combatList.push(AttackChangeAction.getAction(objID, -temp));
			trace(objID + "当前攻击力为:" + attack);
			return temp;
		}
		
		public function BaseCardObj(data:CardData, owner:BaseActObj)
		{
			this.cardData = data;
			this.owner = owner;
			objID = UniqueNameFactory.getUniqueID(this);
			
			init();
		}
		
		/**
		 * 初始化卡牌 
		 * 
		 */		
		protected function init():void
		{
			if (!cardData)
				return;
			
			skills = [];
			// 普通攻击
			attackSkill = new Skill_100(null, this);
			var cardTemplateData:CardTemplateData = CardTemplateDataList.getCardData(cardData.templateID);
			if (cardTemplateData)
			{
				var skillLen:int = cardTemplateData.skillList.length;
				
				for (var i:int = 0; i < skillLen; ++i)
				{
					var skillData:SkillData = SkillDataList.getSkillData(cardTemplateData.skillList[i]);
					if (!skillData)
						continue;
					
					skills.push(GetSkillByID(skillData));
				}
			}
			
			resetCombatData();
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_INITIALIZE, this));
		}
		
		/**
		 * 根据ID获取技能对象 
		 * @param id
		 * @return 
		 * 
		 */		
		public function GetSkillByID(data:SkillData):BaseSkill
		{
			var skillID:String = "centaur.logic.skills.Skill_" + data.templateID.toString();
			var skill:Class= getDefinitionByName(skillID) as Class;
			if (skill != null)	
				return new skill(data, this);
			
			return null;
		}
		
		/**
		 *   更新卡牌的显示模型，分为头像，卡牌主体，放大的卡牌细节
		 */ 
		public function updateRender(skinType:int = SKIN_HEAD_TYPE):void
		{
			if (!render)
				render = new BaseCardRender(this);
			render.updateRenderByType(skinType);
		}
		
		/**
		 * 重置卡牌技能 
		 * 
		 */		
		public function resetCombatData():void
		{
			if (!cardData)
				return;

			buffDic = new Dictionary();	
			
			// 设置血量和攻击力
			this._hp = cardData.maxHP;
			this._attack = cardData.attack;
			this.waitRound = cardData.waitRound;
			this.isDead = false;
		}
		
		/**
		 * 增加卡牌技能 
		 * @param skill
		 * 
		 */		
		public function addSkill(skill:BaseSkill):void
		{
			skill.registerCard(this);
		}
		
		/**
		 * 取消卡牌技能 
		 * @param skill
		 * 
		 */		
		public function removeSkill(skill:BaseSkill):void
		{
			skill.removeCard();
		}
		
		/**
		 * 增加Buff 
		 * @param buffData
		 * 
		 */		
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
		 *  施放技能
		 */ 
		public function onSkill():Boolean
		{
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_SKILL, this));
			
			for (var i:int = 0; i < skills.length; ++i)
			{
				var skill:BaseSkill = skills[i] as BaseSkill;
				skill.doSkill();
			}
			// 检测自身BUFF，技能释放时触发的BUFF
/*			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_SKILL_START, list))
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
			}*/
			
			return isDead;
		}
		
		/**
		 *   被技能攻击
		 */
		public function onSkilled(skillData:SkillData, srcObj:BaseCardObj):int
		{
			lastBeDamagedVal = 0;
			var damage:int;
/*			if (!skillData || !srcObj || !cardData)
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
			damage = SkillLogic.doMagicDefenser(defenseSkill, srcObj, this.owner, list, skillData) as int;*/
			return damage;
		}
		
		/**
		 * 被技能攻击 
		 * @param attacker
		 * @param hurt
		 * 
		 */		
		public function onSkillHurt(attacker:BaseCardObj, hurt:int):int
		{
			// 已经死亡不做处理
			if (this.isDead || hurt <= 0)
				return 0;
			
			// 保存攻击来源
			this.attacker = attacker;
			
			// 设置攻击数值
			lastBeAttackVal = hurt;
			
			// 发送攻击前事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_PRE_SKILL_HURT, this));
			
			// 如果攻击数值小于0,返回
			if (lastBeAttackVal <= 0)
				return 0;
			
			// 扣除生命值
			lastBeDamagedVal = deductHP(lastBeAttackVal);
			
			// 发送攻击后事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_AFTER_SKILL_HURT, this));
			
			// 返回造成的伤害值
			return lastBeDamagedVal;
		}
		
		/**
		 *   普通攻击
		 */ 
		public function onAttack():Boolean
		{
			// 检测自身BUFF，普通攻击时触发的BUFF
/*			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_ATTACK_START, list))
				return true;*/

			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_PRE_ATTACK, this));
			
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_ATTACK, this));
			
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_AFTER_ATTACK, this));
			
			return isDead;
		}
		
		/**
		 * 普通攻击受创 
		 * @param attack
		 * @return 
		 * 
		 */		
		public function onAttackHurt(attacker:BaseCardObj, hurt:int):int
		{
			// 已经死亡不做处理
			if (this.isDead || hurt <= 0)
				return 0;
			
			// 保存攻击来源
			this.attacker = attacker;
			
			// 设置攻击数值
			lastBeAttackVal = hurt;
			
			// 发送攻击前事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_PRE_HURT, this));
			
			// 如果攻击数值小于0,返回
			if (lastBeAttackVal <= 0)
				return 0;
			
			// 扣除生命值
			lastBeDamagedVal = deductHP(lastBeAttackVal);
			
			// 发送攻击后事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_AFTER_HURT, this));
			
			// 返回造成的伤害值
			return lastBeDamagedVal;
		}
		
		/**
		 * 直接造成伤害,不触发任何被动技能
		 * @param damage
		 * 
		 */		
		public function onHurt(damage:int):int
		{
			lastBeDamagedVal = deductHP(damage);
			return lastBeDamagedVal;
		}
		
		/**
		 * 增加或扣除hp
		 * @param num
		 * @return 
		 * 
		 */		
		public function deductHP(num:int):int
		{
			var temp:int = _hp;
			_hp = _hp - num;
			if (_hp <= 0) _hp = 0;
			temp = temp - _hp;
			
			CombatLogic.combatList.push(DamageNotifyAction.getAction(temp, this.objID));
			
			trace(objID + "当前生命值为:" + _hp);
			if (_hp == 0) onDead();
			return temp;
		}
		
		
		/**
		 *   处于濒临死亡时
		 */ 
		public function onDead():void
		{
			if (isDead)
				return;
			
			isDead = true;
			
			// 派发事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_DEAD, this));
			
			if (owner)
				owner.cardToCemeteryArea(this);
		}
		
		/**
		 *   处于出场时
		 */ 
		public function onPresent():void
		{
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_PRESENT, this));
		}
		
		/**
		 *   自身回合开始
		 */ 
		public function onRoundStart():Boolean
		{
/*			// 检测自身BUFF，回合开始时触发的BUFF
			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_ROUND_START, CombatLogic.combatList))
				return true;*/
			
			// 派发事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_ROUND_START, this));
			
			return isDead;
		}
		
		/**
		 *   自身回合结束
		 */ 
		public function onRoundEnd():Boolean
		{
/*			// 检测自身BUFF，回合结束时触发的BUFF
			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_ROUND_END, CombatLogic.combatList))
				return true;*/
			
			// 派发事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_ROUND_END, this));
			
			return isDead;
		}
		
	}
}