package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   回合次数增加操作
	 */ 
	public final class RoundStartAction extends ActionBase
	{
		public var round:int;
		
		public function RoundStartAction()
		{
			type = CombatLogic.ACTION_ROUND_START;
		}
	}
}