package centaur.loader.fam
{
	import centaur.data.GlobalAPI;
	import centaur.manager.EmbedAssetManager;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 *   动画资源管理器
	 */ 
	public final class FamManager
	{
		private var _famBytesDic:Dictionary = new Dictionary();
		private var _famInfoDic:Dictionary = new Dictionary();
		
		public function FamManager()
		{
		}
		
		public function getFamFile(path:String, callback:Function):void
		{
			var famInfo:FanmFileInfo = _famInfoDic[path];
			if (!famInfo)
			{
				var bytes:ByteArray = _famBytesDic[path];
				if (!bytes)
					bytes = GlobalAPI.loaderManager.loadByteArray(path);
				if (!bytes)
				{
					if (callback != null)
						callback(null);
					return;
				}
				
				var famLoader:FamLoader = new FamLoader(path, callback);
				famLoader.load(bytes, onLoadComplete);
				
				function onLoadComplete():void
				{
					_famInfoDic[path] = famLoader.famFile;
					famLoader.dispose();
				}
				
			}
			else if (callback != null)
				callback(famInfo);
		}
	}
}