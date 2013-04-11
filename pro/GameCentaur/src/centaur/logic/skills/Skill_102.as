package centaur.logic.skills
{
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	
	/**
	 * 火球,对随机对方一人造成100-300点伤害 
	 * @author liq
	 * 
	 */	
	public class Skill_102 extends BaseSkill
	{
		public var min:int
		public var max:int;
		
		public function Skill_102(card:BaseCardObj)
		{
			_skillID = 102;
			min = 100;
			max = 300;
			selectTargetType = SkillEnumDefines.TARGET_RANDOM_TYPE;
			
			registerCard(card);
		}
		
		public override function doSkill():void
		{
			if (!card || card.isDead)
				return;
			
			var target:Array = getTarget();
			if (target == null || target.length == 0)
				return;
			
			// 计算伤害
			var hurt:int = min + (max - min) * Math.random();
			var targetCard:BaseCardObj = target[0] as BaseCardObj;
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [targetCard.objID]));
			targetCard.onSkillHurt(card, hurt);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
	}
}