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
	import centaur.logic.buff.BaseBuff;
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
		public var buffs:Array;               // 卡牌Buff
		
		public var lastDamageValue:int;		// 最近一次伤害敌方的伤害值
		public var lastBeAttackVal:int;        // 最近一次受到普通攻击的攻击力
		public var lastBeDamagedVal:int;		// 最近一次受到的伤害值
		public var attacker:BaseCardObj;		// 最近一次攻击我的卡牌
		public var attackerSKill:BaseSkill;    // 最经一次被攻击的技能
		public var target:BaseCardObj;			// 攻击目标
		
		private var _attack:int;               // 卡牌的攻击力
		private var _hp:int;                   // 卡牌的血量
		private var _maxHp:int;                // 卡牌最大血量
		public var waitRound:int;              // 冷却回合数
		public var isDead:Boolean;             // 是否已经死亡
		public var attackSkill:BaseSkill;      // 普通攻击技能
		
		
		public var isActive:Boolean = true;   // 是否可行动
		public var canAttack:Boolean = true;  // 是否可攻击
		public var canCure:Boolean = true;    // 是否可治疗
		
		public function get attack():int
		{
			return this._attack;
		}

		/**
		 * 判断是否满血 
		 * @return 
		 * 
		 */		
		public function get isHurt():Boolean
		{
			return _hp < _maxHp;
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
			// attackSkill = new Skill_100(null, this);
			var cardTemplateData:CardTemplateData = CardTemplateDataList.getCardData(cardData.templateID);
			if (cardTemplateData)
			{
				// 普通攻击技能
				var skillID:int = cardTemplateData.normolAttID;
				var skillData:SkillData = null;
				var skill:BaseSkill = null;
				if (skillID > 0)
					skills.push(BaseSkill.getSkillByID(this, skillID, []));
				
				skillID = cardTemplateData.skill1ID;
				if (skillID > 0)
					skills.push(BaseSkill.getSkillByID(this, skillID, cardTemplateData.skill1Para));
				
				skillID = cardTemplateData.skill2ID;
				if (skillID > 0)
					skills.push(BaseSkill.getSkillByID(this, skillID, cardTemplateData.skill2Para));
				
				skillID = cardTemplateData.skill3ID;
				if (skillID > 0)
					skills.push(BaseSkill.getSkillByID(this, skillID, cardTemplateData.skill3Para));
			}
			
			resetCombatData();
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_INITIALIZE, this));
		}
		
		
		/**
		 * 增加一个buff 
		 * @param buff
		 * 
		 */		
		public function addBuff(buff:BaseBuff):void
		{
			// 不可叠加的buff先看下是否存在
			if (buff.superposition == 0 && hasBuff(buff.id))
			{
				return;
			}
			
			buff.addBuff();
			buffs.push(buff);
		}
		
		/**
		 *  去掉一个buff 
		 * @param buff
		 * 
		 */		
		public function deBuff(buff:BaseBuff):void
		{
			var idx:int = buffs.indexOf(buff);
			if (idx != -1)
				buffs.splice(idx, 1);
		}
		
		/**
		 * 是否已经存在Buff 
		 * @param buffID
		 * @return 
		 * 
		 */		
		public function hasBuff(buffID:int):Boolean
		{
			for (var i:int = 0; i < buffs.length; i++)
			{
				var bf:BaseBuff = buffs[i] as BaseBuff;
				if (bf.id == buffID && bf.round > 0)
					return true;
			}
			
			return false;
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
		
		public function clearRender():void
		{
			if (render)
				render.dispose();
			render = null;
		}
		
		/**
		 * 重置卡牌技能 
		 * 
		 */		
		public function resetCombatData():void
		{
			if (!cardData)
				return;

			buffs = [];	
			
			// 设置血量和攻击力
			this._hp = cardData.maxHP;
			this._maxHp = cardData.maxHP;
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
		 *  施放技能
		 */ 
		public function onSkill():Boolean
		{
			if (!isActive)
				return false;
			
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_SKILL, this));
			
			for (var i:int = 0; i < skills.length; ++i)
			{
				var skill:BaseSkill = skills[i] as BaseSkill;
				if (skill != null && skill.skillType == SkillEnumDefines.SKILL_ACTIVE_TYPE)
					skill.doSkill();
			}
			
			return isDead;
		}
		
		
		/**
		 * 被技能攻击 
		 * @param attacker
		 * @param damage
		 * 
		 */		
		public function onSkillHurt(attacker:BaseSkill, damage:int):int
		{
			// 已经死亡不做处理
			if (this.isDead)
				return 0;
			
			// 保存攻击来源
			this.attacker = attacker.card;
			
			// 保存攻击的技能
			this.attackerSKill = attacker;
			
			// 设置攻击数值
			lastBeAttackVal = damage;
			
			// 发送攻击前事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_PRE_SKILL_HURT, this));
			
			// 如果攻击数值小于0,返回
			if (lastBeAttackVal <= 0)
				return lastBeAttackVal;
			
			// 扣除生命值
			lastBeDamagedVal = deductHP(lastBeAttackVal, false);
			
			// 发送攻击后事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_AFTER_SKILL_HURT, this));
			
			if (hp == 0)
				onDead();
			
			// 返回造成的伤害值
			return lastBeDamagedVal;
		}
		
		/**
		 *   普通攻击
		 */ 
		public function onAttack():Boolean
		{
			if (!isActive || !canAttack)
				return false;
			
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
				return lastBeAttackVal;
			
			// 扣除生命值
			lastBeDamagedVal = deductHP(lastBeAttackVal, false);
			
			//  攻击成功事件
			if (lastBeDamagedVal > 0 && !attacker.isDead)
			{
				attacker.lastDamageValue = lastBeDamagedVal;
				attacker.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_ATTACK_SUCC, attacker));
			}
			
			// 发送攻击后事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_AFTER_HURT, this));
			
			if (hp == 0)
				onDead();
			
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
		public function deductHP(num:int, checkDead:Boolean = true):int
		{
			if (isDead)
				return 0;
			
			var temp:int = _hp;
			_hp = _hp - num;
			if (_hp <= 0) _hp = 0;
			temp = temp - _hp;
			
			CombatLogic.combatList.push(DamageNotifyAction.getAction(temp, this.objID));
			
			trace(objID + "当前生命值为:" + _hp);
			if (checkDead && _hp == 0) onDead();
			return temp;
		}
		
		/**
		 * 增加HP 
		 * @param num
		 * @return 
		 * 
		 */		
		public function addHP(num:int):int
		{
			if (_hp >= _maxHp || !canCure)
				return 0;
			
			var temp:int = _hp;
			_hp = _hp + num;
			if (_hp > _maxHp) _hp = _maxHp;
			temp = _hp - temp;
			
			CombatLogic.combatList.push(CureNotifyAction.getAction(temp, this.objID));
			
			trace(objID + "当前生命值为:" + _hp);
			return temp;
		}
		
		/**
		 * 增加HP最大值 
		 * @param num
		 * 
		 */		
		public function addMaxHp(num:int):void
		{
			_maxHp += num;
			_hp += num;
			
			// 加入Action
			CombatLogic.combatList.push(MaxHpChangeAction.getAction(num, num, this.objID));
		}
		
		/**
		 * 减少HP最大值 
		 * @param num
		 * 
		 */		
		public function deductMaxHp(num:int):void
		{
			_maxHp -= num;
			if (_maxHp < 0) _maxHp = 0;
			var temp:int = _hp;
			if (_hp > _maxHp) _hp = _maxHp;
			
			// 加入Action
			CombatLogic.combatList.push(MaxHpChangeAction.getAction(-num, _hp - temp, this.objID));
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
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_PRE_DEAD, this));
			
			// resetCombatData();
			
			if (owner)
				owner.cardToCemeteryArea(this);
			
			// 派发事件
			this.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_AFTER_DEAD, this));
		}
		
		/**
		 * 卡牌直接死亡,不触发死亡事件 
		 * 
		 */		
		public function doDead():void
		{
			if (isDead)
				return;
			
			isDead = true;
			
			if (owner)
				owner.cardToCemeteryArea(this);
		}
		
		/**
		 * 卡牌回到牌堆 
		 * 
		 */		
		public function doBack():void
		{
			if (owner)
				owner.cardToCardArea(this);
		}
		
		/**
		 * 卡牌复活 进入等待区
		 * 
		 */		
		public function doReturn():void
		{
			if (!isDead)
				return;
			
			if (owner)
				owner.cardReturn(this);
		}
		
		/**
		 * 卡牌复活 
		 * 
		 */		
		public function doRevive():void
		{
			if (!isDead)
				return;
			
			if (owner)
				owner.cardRevive(this);
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