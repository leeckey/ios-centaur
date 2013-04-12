package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.RoundStartAction;

	/**
	 *   处理回合开始时的操作
	 *   @author wangq 2013.04.12
	 */ 
	public final class RoundStartHandler extends ActionHandler
	{
		public function RoundStartHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:RoundStartAction = action as RoundStartAction;
			if (!actionData)
				return;
			
			CombatPanel.instance.onRoundStart(actionData.round);
		}
	}
}