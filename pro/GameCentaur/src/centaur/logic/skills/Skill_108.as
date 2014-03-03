package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 立即杀死敌方一张卡片
	 * @author liq
	 * 
	 */	
	public class Skill_108 extends BaseSkill
	{	
		public function Skill_108(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
		}
		
		/**
		 * 立即杀死敌方一张卡片
		 * @param targetCard
		 * 
		 */		
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			if (targetCard.onSkillHurt(this, 0) >= 0)
			{
				targetCard.doDead();
			}
		}
		
	}
}