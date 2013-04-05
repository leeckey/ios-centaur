package centaur.logic.action
{
	import centaur.data.combat.CombatData;
	import centaur.logic.combat.CombatLogic;

	public final class RoundEndAction extends ActionBase
	{
		public var round:int;
		
		public function RoundEndAction()
		{
			type = ACTION_ROUND_END;
		}
		
		public static function getAction(round:int):RoundEndAction
		{
			var action:RoundEndAction = new RoundEndAction();
			action.round = round;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return "第" + round + "回合结束";
		}
	}
}