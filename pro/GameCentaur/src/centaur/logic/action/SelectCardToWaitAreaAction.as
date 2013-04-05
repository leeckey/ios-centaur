package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   选择卡牌到等待队列的操作
	 */ 
	public final class SelectCardToWaitAreaAction extends ActionBase
	{
		// 卡牌ID
		public var cardID:int;
		
		public function SelectCardToWaitAreaAction()
		{
			type = ACTION_SELECT_TO_WAITAREA;
		}
		
		public static function getAction(ownerID:int, cardID:int):SelectCardToWaitAreaAction
		{
			var action:SelectCardToWaitAreaAction = new SelectCardToWaitAreaAction();
			action.srcObj = ownerID;
			action.cardID = cardID;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return "卡牌" + cardID + "进入等待区";
		}
	}
}