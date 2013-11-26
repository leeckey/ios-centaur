package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 将正面敌方卡牌送回牌堆
	 * @author liq
	 * 
	 */	
	public class Skill_109 extends BaseSkill
	{
		public function Skill_109(data:SkillData, card:BaseCardObj)
		{
			super(data, card);
		}
		
		/**
		 * 将正面敌方卡牌送回牌堆
		 * @param targetCard
		 * 
		 */		
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			if (targetCard.onSkillHurt(this, 0) >= 0)
			{
				targetCard.doBack();
			}
		}
	}
}