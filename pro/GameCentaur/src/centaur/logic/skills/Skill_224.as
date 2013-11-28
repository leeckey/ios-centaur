package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.action.*;
	
	/**
	 * 不受摧毁,送还,传送技能影响
	 * @author liq
	 * 
	 */	
	public class Skill_224 extends BaseSkill
	{
		private var skills:Array = [60, 61, 62];
		
		public function Skill_224(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
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
		 * 不受摧毁,送还,传送技能影响
		 * @param event
		 * 
		 */		
		public function onPreSkillHurt(event:CardEvent):void
		{
			if (card.attackerSKill.skillID >= 0 && skills.indexOf(card.attackerSKill.skillID) != -1)
			{				
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
				card.lastBeAttackVal = -1;
				trace(card.objID + "免疫了摧毁,送还,传送技能影响");
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			}
		}
	}
}