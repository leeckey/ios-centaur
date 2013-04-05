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
			type = ACTION_ROUND_START;
		}
		
		public static function getAction(round:int):RoundStartAction
		{
			var action:RoundStartAction = new RoundStartAction();
			action.round = round;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return "第" + round + "回合开始";
		}
	}
}