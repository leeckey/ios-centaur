package centaur.data
{
	import centaur.display.ui.combat.handler.ActionHandlerManager;
	import centaur.effects.EffectManager;
	import centaur.loader.LoaderManager;
	import centaur.manager.LayerManager;
	import centaur.manager.PathManager;
	import centaur.manager.TickManager;

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
		
		public function GlobalAPI()
		{
		}
	}
}