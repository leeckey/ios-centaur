package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.RoundEndAction;

	/**
	 *   处理回合结束时的操作
	 *   @author wangq 2013.04.12
	 */ 
	public final class RoundEndHandler extends ActionHandler
	{
		public function RoundEndHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:RoundEndAction = action as RoundEndAction;
			if (!actionData)
				return;
			
			CombatPanel.instance.onRoundEnd(actionData.round);
		}
	}
}