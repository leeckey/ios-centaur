package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	
	/**
	 * 王国之力：提升除自己之外所有蜀国卡牌100点攻击力 
	 * @author liq
	 * 
	 */	
	public class Skill_216 extends BaseSkill
	{	
		/**
		 * 提升的攻击力 
		 */		
		public var attack:int;
		
		public function Skill_216(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
		}
		
		/**
		 * 设置卡牌参数 
		 * @param data
		 * 
		 */		
		public override function initConfig(data:SkillData):void
		{
			// 设置公共信息
			super.initConfig(data);
			
			attack = data.param1 * skillLevel;
		}
		
		/**
		 * 监听卡牌上场事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_PRESENT, onPresent, false, _priority);
			}
		}
		
		/**
		 * 取消事件监听 
		 * 
		 */		
		public override function removeCard():void
		{
			if (card != null)
			{
				card.removeEventListener(CardEvent.ON_PRESENT, onPresent);
			}
			
			super.removeCard();
		}
		
		/**
		 * 出场时增加场上相同卡牌的攻击力 
		 * @param event
		 * 
		 */		
		public function onPresent(event:CardEvent):void
		{
			card.addEventListener(CardEvent.ON_PRE_DEAD, onDead);
			
			// 找到相同国家的卡牌
			var targets:Array = getTarget();
			
			if (targets != null && targets.length != 0)
			{				
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, makeIDArray(targets)));
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
				
				// 增加攻击力
				var target:BaseCardObj;
				for (var i:int = 0; i < targets.length; i++)
				{
					target = targets[i] as BaseCardObj;
					if (target != card)
						target.addAttack(attack);
				}
			}
			
			// 监听所有未上场的卡牌
			targets = card.owner.combatData.getCardByCountry(card.cardData.country);
			for (i = 0; i < targets.length; i++)
			{
				target = targets[i] as BaseCardObj;
				if (target != null && target.objID != card.objID)
					target.addEventListener(CardEvent.ON_PRESENT, onOtherCardPresent);
			}
		}
		
		/**
		 * 相同国家其他卡牌上场也要增加攻击力 
		 * @param event
		 * 
		 */		
		public function onOtherCardPresent(event:CardEvent):void
		{
			var target:BaseCardObj = event.card;
			if (target != null)
			{
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [target.objID]));
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
				target.addAttack(attack);
			}
		}
		
		
		/**
		 * 死亡时相同国家的卡恢复攻击力 
		 * @param event
		 * 
		 */		
		public function onDead(event:CardEvent):void
		{
			card.removeEventListener(CardEvent.ON_PRE_DEAD, onDead);
			var targets:Array = getTarget();
			
			if (targets != null && targets.length != 0)
			{				
				// 恢复攻击力
				var target:BaseCardObj;
				for (var i:int = 0; i < targets.length; i++)
				{
					target = targets[i] as BaseCardObj;
					if (target != card)
						target.deductAttack(attack);
				}
			}
			
			// 取消监听所有未上场的卡牌
			targets = card.owner.combatData.getCardByCountry(card.cardData.country);
			for (i = 0; i < targets.length; i++)
			{
				target = targets[i] as BaseCardObj;
				if (target != null && target.objID != card.objID)
					target.removeEventListener(CardEvent.ON_PRESENT, onOtherCardPresent);
			}
		}
	}
}