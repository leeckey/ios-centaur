package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	public final class SkillAttackAction extends ActionBase
	{
		public var skillID:uint;
		public var damage:uint;
		
		public function SkillAttackAction()
		{
			type = CombatLogic.ACTION_SKILL;
		}
	}
}