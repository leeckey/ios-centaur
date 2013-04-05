package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   将卡牌转移到墓地区操作
	 */ 
	public final class SelectCardToCemeteryArea extends ActionBase
	{
		public var cardID:uint;
			
		public function SelectCardToCemeteryArea()
		{
			type = ACTION_SELECT_TO_CEMETERYAREA;
		}
		
		
		public static function getAction(ownerID:int, cardID:int):SelectCardToCemeteryArea
		{
			var action:SelectCardToCemeteryArea = new SelectCardToCemeteryArea();
			action.cardID = cardID;
			action.srcObj = ownerID;
			
			trace(action.toString());
			return action;
		}
		
		
		public override function toString():String
		{
			return "卡牌" + cardID + "进入墓地";
		}
	}
}