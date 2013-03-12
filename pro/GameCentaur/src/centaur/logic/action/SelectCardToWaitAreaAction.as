package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	public final class SelectCardToWaitAreaAction extends ActionBase
	{
		public var index:int;
		
		public function SelectCardToWaitAreaAction()
		{
			type = CombatLogic.ACTION_SELECT_TO_WAITAREA;
		}
	}
}