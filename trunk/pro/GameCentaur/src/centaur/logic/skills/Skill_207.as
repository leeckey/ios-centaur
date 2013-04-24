package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.action.*;
	
	/**
	 * 免疫技能 
	 * @author liq
	 * 
	 */	
	public class Skill_207 extends BaseSkill
	{
		public function Skill_207(data:SkillData, card:BaseCardObj)
		{
			super(data, card);
		}
		
		/**
		 * 监听受到技能伤害事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_PRE_SKILL_HURT, onPreSkillHurt, false, _priority);
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
				card.removeEventListener(CardEvent.ON_PRE_SKILL_HURT, onPreSkillHurt);
			}
			
			super.removeCard();
		}
		
		/**
		 * 免疫技能伤害
		 * @param event
		 * 
		 */		
		public function onPreSkillHurt(event:CardEvent):void
		{
			if (card.lastBeAttackVal > 0)
			{				
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
				card.lastBeAttackVal = 0;
				trace(card.objID + "免疫了技能伤害");
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			}
		}
	}
}