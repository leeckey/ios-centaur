package centaur.loader
{
	import centaur.loader.fam.FamManager;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**
	 *   加载管理器,资源加载都归它管
	 */ 
	public class LoaderManager
	{
		private var _famManager:FamManager;
		private var _bitmapManager:BitmapDataManager;
		
		public function LoaderManager()
		{
			init();
		}
		
		protected function init():void
		{
			_famManager = new FamManager();
			_bitmapManager = new BitmapDataManager();
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
		
		public function getBitmapInstance(path:String):BitmapData
		{
			return _bitmapManager.getBitmapData(path);
		}

		public function loadGBKString(path:String):String
		{
			return null;
		}
		
		public function loadByteArray(path:String):ByteArray
		{
			return null;
		}
		
	}
}