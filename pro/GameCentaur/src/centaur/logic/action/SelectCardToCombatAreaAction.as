package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   选择卡牌到战斗队列的操作
	 */ 
	public final class SelectCardToCombatAreaAction extends ActionBase
	{
		// 卡牌ID
		public var cardID:int;
		
		public function SelectCardToCombatAreaAction()
		{
			type = ACTION_SELECT_TO_COMBATAREA;
		}
		
		public static function getAction(ownerID:int, cardID:int):SelectCardToCombatAreaAction
		{
			var action:SelectCardToCombatAreaAction = new SelectCardToCombatAreaAction();
			action.srcObj = ownerID;
			action.cardID = cardID;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return "卡牌" + cardID + "进入战斗区";
		}
	}
}