package centaur.data
{
	import centaur.display.ui.combat.handler.ActionHandlerManager;
	import centaur.effects.EffectManager;
	import centaur.interfaces.ITimerManager;
	import centaur.loader.LoaderManager;
	import centaur.manager.LayerManager;
	import centaur.manager.PathManager;
	import centaur.manager.TickManager;
	
	import net.HttpNetManager;

	/**
	 *  全局API
	 */ 
	public final class GlobalAPI
	{
		// 路径管理器
		public static var pathManager:PathManager;	
		
		// tick管理器
		public static var tickManager:TickManager;
		
		// loader管理器
		public static var loaderManager:LoaderManager;
		
		// 战斗动作处理器
		public static var actionHandlerManager:ActionHandlerManager;
		
		// 效果管理器
		public static var effectManager:EffectManager;
		
		// 层次管理器
		public static var layerManager:LayerManager;
		
		// 定时器管理器
		public static var timerManager:ITimerManager;
		
		// Http网络管理器
		public static var httpManager:HttpNetManager;
	}
}