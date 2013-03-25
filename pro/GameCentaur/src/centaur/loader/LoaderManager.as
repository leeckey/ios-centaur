package centaur.loader
{
	import centaur.loader.fam.FamManager;
	
	import flash.system.ApplicationDomain;

	/**
	 *   加载管理器,资源加载都归它管
	 */ 
	public final class LoaderManager
	{
		private var _famManager:FamManager;
		
		public function LoaderManager()
		{
			init();
		}
		
		protected function init():void
		{
			_famManager = new FamManager();
		}
		
		public function getFamFile(path:String, callback:Function):void
		{
			_famManager.getFamFile(path, callback);
		}
		
		public function removeFamFile(path:String):void
		{
			
		}
		
		
		public static function getClassByPathAndDomain(path:String, dm:ApplicationDomain = null):Class
		{
			try
			{
				if (!dm)
					dm = ApplicationDomain.currentDomain;
				return dm.getDefinition(path) as Class;
			}
			catch (e:Error)
			{
			}
			return null;
		}

	}
}