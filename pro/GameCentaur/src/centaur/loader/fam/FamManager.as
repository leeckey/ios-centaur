package centaur.loader.fam
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 *   动画资源管理器
	 */ 
	public final class FamManager
	{
		[Embed(source="E:/Game/pro/assets/effects/jgjf01.fam",mimeType="application/octet-stream")]
		public static var FamTestBytes:Class;
		
		private var _famBytesDic:Dictionary = new Dictionary();
		private var _famInfoDic:Dictionary = new Dictionary();
		
		public function FamManager()
		{
			////----wangq 测试用
			setupData(new FamTestBytes());
		}
		
		public function setupData(bytes:ByteArray):void
		{
			_famBytesDic["fortest"] = bytes;
		}
		
		public function getFamFile(path:String, callback:Function):void
		{
			var famInfo:FanmFileInfo = _famInfoDic[path];
			if (!famInfo)
			{
				var bytes:ByteArray = _famBytesDic[path];
				if (!bytes)
					return;
				
				var famLoader:FamLoader = new FamLoader(path, callback);
				famLoader.load(bytes, onLoadComplete);
				
				function onLoadComplete():void
				{
					_famInfoDic[path] = famLoader.famFile;
					famLoader.dispose();
				}
				
			}
			else if (callback != null)
				callback(path);
		}
	}
}