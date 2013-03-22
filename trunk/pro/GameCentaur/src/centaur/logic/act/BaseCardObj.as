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
	import centaur.logic.combat.SkillLogic;
	import centaur.logic.render.BaseCardRender;
	import centaur.utils.UniqueNameFactory;
	
	import flash.utils.Dictionary;
	
	import mx.controls.List;

	/**
	 *   卡牌数据对象
	 */ 
	public class BaseCardObj
	{
		public var objID:uint;
		
		public var owner:BaseActObj;
		public var cardData:CardData;
		public var render:BaseCardRender;
		public var skillDic:Dictionary;
		public var buffDic:Dictionary;
		
		public var lastDamageValue:int;			// 最近一次伤害敌方的伤害值
		public var lastBeDamagedVal:int;		// 最近一次受到的伤害值
		
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
			
			for (var i:int = 0; i < len; ++i)
			{
				if (checkDead())
					return true;
				
				var skillData:SkillData = atkSkillList[i];
				SkillLogic.doSkiller(skillData, this, targetActObj, list);
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
			
			// 受技能攻击时，与自身防御技能相计算
			var defenseSkillList:Array = skillDic[SkillEnumDefines.SKILL_MAGIC_DEFENSE_TYPE];
			var len:int = defenseSkillList ? defenseSkillList.length : 0;
			var defenseSkill:SkillData = (len > 0) ? defenseSkillList[0] : null;
			if (defenseSkill && defenseSkill.avoidMagicDamage)	// 无视魔法伤害,魔免
			{
				list.push(SkillEffectAction.addSkillEffect(srcObj.objID, this.objID, defenseSkill.templateID, null));	// 魔免效果
				return damage;
			}
			if (defenseSkill && defenseSkill.avoidMagicDamageRatio > 0 &&
				Math.random() * 100 <= defenseSkill.avoidMagicDamageRatio)	// 闪避魔法伤害判定
			{
				list.push(SkillEffectAction.addSkillEffect(srcObj.objID, this.objID, defenseSkill.templateID, null));	// 闪避效果
				return damage;
			}
			
			// 优先计算技能伤害
			damage = calcSkilledDamage(srcObj, skillData, defenseSkill, list);
			list.push(DamageNotifyAction.addDamageAction(damage, this.objID));	// 伤害操作
			srcObj.lastDamageValue = lastBeDamagedVal = damage;
			
			// 如果已经死亡，不需要判断BUFF伤害等，直接进入濒临死亡状态
			if (checkDead())
				return damage;
			
			// 处理反弹伤害效果,如果已死是没机会反弹的
			if (defenseSkill && defenseSkill.reflexMagicDamage > 0)
			{
				SkillLogic.doSkiller(defenseSkill, this, srcObj.owner, list);
			}
			
			// 增加持续伤害或BUFF，到BUFF点结算，BUFF点一般为回合开始，回合结束等
			if (skillData.durationRound > 0)
			{
				var buffData:BuffData = new BuffData(skillData.buffType, skillData.templateID, skillData.durationRound);
				addBuff(buffData);
				list.push(BuffNotifyAction.addBuffAction(buffData, this.objID));
			}
			
			// 计算属性变更, 属性变更是否只是当前回合,回合结束时还得恢复？这个还不确定，下面暂时简单处理
			if (skillData.attackChange != 0 && !skillData.isAffectSelf)
			{
				cardData.attack += skillData.attackChange;
				cardData.attack = (cardData.attack < 0) ? 0 : cardData.attack;
			}
			if (skillData.hpChange != 0 && !skillData.isAffectSelf)
			{
			}
			
			// 判断是否死亡
			checkDead();
			return damage;
		}
		
		/**
		 *   计算受技能攻击时的伤害量
		 */ 
		private function calcSkilledDamage(srcObj:BaseCardObj, skillData:SkillData, defenseSkill:SkillData, list:Array):int
		{
			var damage:int;
			var skillDamage:Number = (skillData.skillType == SkillEnumDefines.SKILL_MAGIC_DEFENSE_TYPE) ? skillData.reflexMagicDamage : skillData.damage;
			if (skillDamage != 0)
			{
				// 技能伤害这块有点细节，如果当前是被攻击型技能攻击，根据技能damage和目标血量计算百分比（如果配置是百分比掉血的话）
				// 如果技能是防御型反弹技能，根据技能reflexMagicDamage和自身受的伤害计算百分比（反弹自身受伤害的百分比）
				var baseVal:int = (skillData.skillType == SkillEnumDefines.SKILL_MAGIC_DEFENSE_TYPE) ? srcObj.lastBeDamagedVal : cardData.hp;
				damage = (skillDamage < 1 && skillDamage > -1) ? skillDamage * baseVal : skillDamage;
				if (defenseSkill)		// 计算防御技能的伤害减少或最大伤害值
				{
					if (defenseSkill.maxDamageWhenMagic > 0)
						damage = defenseSkill.maxDamageWhenMagic;
					if (defenseSkill.reduceMagicDamage > 0)
					{
						list.push(SkillEffectAction.addSkillEffect(srcObj.objID, this.objID, defenseSkill.templateID, null));	// 减伤效果
						damage -= defenseSkill.reduceMagicDamage;
					}
				}
				
				if (0 == damage)
					damage = skillDamage > 0 ? 1 : -1;
				var newHP:int = cardData.hp - damage;
				if (newHP <= 0)
				{
					damage = cardData.hp;
					cardData.hp = 0;
				}
				else
					cardData.hp = newHP;
			}
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
			
			var defenseSkillList:Array = skillDic[SkillEnumDefines.SKILL_ATTACK_DEFENSE_TYPE];
			var defenseSkill:SkillData = defenseSkillList ? defenseSkillList[0] : null;
			if (defenseSkill && defenseSkill.avoidAttackDamage)		// 物理免疫
			{
				return damage;
			}
			if (defenseSkill && defenseSkill.avoidAttackDamageRatio > 0 && 
				100 * Math.random() <= defenseSkill.avoidAttackDamageRatio)	// 物理闪避		
			{
				return damage;
			}
			
			damage = calcAttackedDamage(srcObj, atkSkillData, defenseSkill, list);	
			list.push(DamageNotifyAction.addDamageAction(damage, this.objID));	// 伤害操作
			srcObj.lastDamageValue = this.lastBeDamagedVal = damage;
			
			// 如果已经死亡，不需要判断BUFF伤害等，直接进入濒临死亡状态
			if (checkDead())
				return damage;
			
			// 反弹物理伤害
			
			// 增加持续伤害或BUFF，到BUFF点结算，BUFF点一般为回合开始，回合结束等
			if (atkSkillData && atkSkillData.durationRound > 0)
			{
				var buffData:BuffData = new BuffData(atkSkillData.buffType, atkSkillData.templateID, atkSkillData.durationRound);
				addBuff(buffData);
				list.push(BuffNotifyAction.addBuffAction(buffData, this.objID));
			}
			
			// 计算属性变更, 属性变更是否只是当前回合,回合结束时还得恢复？这个还不确定，下面暂时简单处理
			if (atkSkillData && atkSkillData.attackChange != 0 && !atkSkillData.isAffectSelf)
			{
				cardData.attack += atkSkillData.attackChange;
				cardData.attack = (cardData.attack < 0) ? 0 : cardData.attack;
			}
			if (atkSkillData && atkSkillData.hpChange != 0 && !atkSkillData.isAffectSelf)
			{
			}
			
			// 判断是否死亡
			checkDead();
			return damage;
		}
		
		private function calcAttackedDamage(srcObj:BaseCardObj, atkSkillData:SkillData, defenseSkill:SkillData, list:Array):int
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
			var newHP:int = cardData.hp - damage;
			if (newHP <= 0)
			{
				damage = cardData.hp;
				cardData.hp = 0;
			}
			else
				cardData.hp = newHP;
			
			return damage;
		}
		
		/**
		 *   处于濒临死亡时
		 */ 
		public function onDead():void
		{
			var deathSkill:SkillData = skillDic[SkillEnumDefines.SKILL_DEATH_TYPE];
			if (deathSkill)
			{
				// 死契技能处理
				SkillLogic.doDeathSkiller(deathSkill, this, this.owner.enemyActObj, CombatLogic.combatList);
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
			var presentSkill:SkillData = skillDic[SkillEnumDefines.SKILL_PRESENT_TYPE];
			if (!presentSkill)
				return;
			
			// 降临技能处理
			SkillLogic.doPresentSkiller(presentSkill, this, this.owner.enemyActObj, CombatLogic.combatList);
		}
		
		/**
		 *   受到降临技能时
		 */ 
		public function onPresented():void
		{
		}
		
		/**
		 *   自身回合开始
		 */ 
		public function onRoundStart():Boolean
		{
			// 检测自身BUFF，回合开始时触发的BUFF
			if (BuffLogic.doBuffer(this, SkillEnumDefines.BUFF_ROUND_START, CombatLogic.combatList))
				return true;
			
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