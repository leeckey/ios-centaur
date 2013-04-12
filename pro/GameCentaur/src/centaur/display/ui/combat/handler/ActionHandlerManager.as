package centaur.display.ui.combat.handler
{
	import centaur.logic.action.ActionBase;

	/**
	 *   处理战斗操作的管理器
	 *   @author wangq 2013.04.12
	 */ 
	public final class ActionHandlerManager
	{
		public function ActionHandlerManager()
		{
		}
		
		public function handle(actionBase:ActionBase):ActionHandler
		{
			if (!actionBase)
				return null;
			
			var handler:ActionHandler = ActionHandlerFactory.getInstance(actionBase);
			handler.doHandler();
			return handler;
		}
	}
}