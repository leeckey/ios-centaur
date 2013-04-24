package centaur.logic.action
{
	/**
	 * 卡牌回到牌堆操作 
	 * @author liq
	 * 
	 */	
	public class SelectCardToCardAreaAction extends ActionBase
	{
		// 卡牌ID
		public var cardID:int;
		
		public function SelectCardToCardAreaAction()
		{
			type = ACTION_SELECT_TO_CARDAREA;
		}
		
		public static function getAction(ownerID:int, cardID:int):SelectCardToCardAreaAction
		{
			var action:SelectCardToCardAreaAction = new SelectCardToCardAreaAction();
			action.srcObj = ownerID;
			action.cardID = cardID;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return "卡牌" + cardID + "进入卡堆区";
		}
	}
}