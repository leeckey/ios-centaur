package centaur.data
{
	import centaur.loader.LoaderManager;
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
		
		public function GlobalAPI()
		{
		}
	}
}