package centaur.logic.action
{
	import centaur.data.combat.CombatData;
	import centaur.logic.combat.CombatLogic;

	public final class RoundEndAction extends ActionBase
	{
		public var round:int;
		
		public function RoundEndAction()
		{
			type = CombatLogic.ACTION_ROUND_END;
		}
		
		
	}
}