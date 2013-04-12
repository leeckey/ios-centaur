package centaur.display.ui.combat.handler
{
	import centaur.logic.action.ActionBase;

	/**
	 *   处理战斗操作的基类
	 *   @author wangq 2013.04.12
	 */ 
	public class ActionHandler
	{
		public var castTime:int;		// 操作耗时,默认值0.5s
		public var action:ActionBase;	// 操作数据
		
		public function ActionHandler(action:ActionBase)
		{
			data = action;
			castTime = 500;
		}
		
		public function set data(action:ActionBase):void
		{
			this.action = action;
		}
		
		public function doHandler():void
		{
		}
	}
}