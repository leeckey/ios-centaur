package centaur.logic.skills
{
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.action.*;
	
	
	/**
	 * 普通攻击技能 
	 * @author minnie
	 * 
	 */	
	public class Skill_100 extends BaseSkill
	{
		public function Skill_100(card:BaseCardObj)
		{
			selectTargetType = SkillEnumDefines.TARGET_SELF_FRONT_TYPE;
			
			registerCard(card);
		}
		
		/**
		 * 监听攻击事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			if (card != null)
				card.addEventListener(CardEvent.ON_ATTACK, onAttack);
		}
		
		/**
		 * 取消监听卡牌 
		 * @param card
		 * 
		 */		
		public override function removeCard():void
		{
			if (card != null)
				card.removeEventListener(CardEvent.ON_ATTACK, onAttack);
			
			super.removeCard();
		}
		
		/**
		 * 普通攻击处理 
		 * @param event
		 * 
		 */		
		private function onAttack(event:CardEvent):void
		{
			if (!card || card.isDead || card.attack <= 0)
				return;
			
			// 寻找目标
			var target:Array = getTarget();
			
			// 发起攻击
			if (target == null || target.length == 0)
			{
				// 攻击对方玩家
				CombatLogic.combatList.push(AttackEffectAction.getAction(card.objID, card.owner.enemyActObj.objID));
				card.owner.enemyActObj.deductHp(card.attack);
			}
			else
			{
				// 攻击对面的卡牌
				var targetCard:BaseCardObj = target[0] as BaseCardObj;
				
				CombatLogic.combatList.push(AttackEffectAction.getAction(card.objID, targetCard.objID));
				
				card.lastDamageValue = targetCard.onAttackHurt(card, card.attack);
				
				if (!card.isDead && card.lastDamageValue > 0)
					card.dispatchEvent(CardEvent.EventFactory(CardEvent.ON_ATTACK_SUCC, card));
			}
			
		}
	}
}