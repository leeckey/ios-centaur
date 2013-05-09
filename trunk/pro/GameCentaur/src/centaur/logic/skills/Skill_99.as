package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 普通攻击技能 
	 * @author minnie
	 * 
	 */	
	public class Skill_99 extends BaseSkill
	{
		public function Skill_99(data:SkillData, card:BaseCardObj)
		{
			super(data, card);
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
				card.addEventListener(CardEvent.ON_ATTACK, onAttack, false, _priority);
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
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.owner.enemyActObj.objID]));
				// CombatLogic.combatList.push(AttackEffectAction.getAction(card.objID, card.owner.enemyActObj.objID));
				card.owner.enemyActObj.deductHp(card.attack);
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			}
			else
			{
				// 攻击对面的卡牌
				
				var targetCard:BaseCardObj = target[0] as BaseCardObj;
				
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [targetCard.objID]));
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
				// CombatLogic.combatList.push(AttackEffectAction.getAction(card.objID, targetCard.objID));
				card.target = targetCard;
				targetCard.onAttackHurt(card, card.attack);
			}
			
			
		}
	}
}