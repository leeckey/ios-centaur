package centaur.loader.fam
{
	import centaur.loader.LoaderManager;
	import centaur.loader.loaderdata.PacckageFileData;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 *   fam资源加载
	 */ 
	public final class FamLoader
	{
		public var famFile:FanmFileInfo;		// 动画数据
		public var bytes:ByteArray;				// 二进制源文件
		public var isError:Boolean;				// 是否加载错误
		public var path:String;					// 路径
		private var _swfLoader:Loader;			// swf加载器
		private var _callbackList:Array;		// 加载结束的回调函数
		
		public function FamLoader(path:String, callback:Function)
		{
			this.path = path;
			addCallback(callback);
		}
		
		public function load(bytes:ByteArray, callback:Function = null):void
		{
			this.bytes = bytes;
			addCallback(callback);
			
			famFile = new FanmFileInfo();
			famFile.path = path;
			famFile.datas = bytes;
			
			if (famFile.swfBytes)
			{
				var loaderConext:LoaderContext = new LoaderContext();
				loaderConext.allowCodeImport = true;
				_swfLoader = new Loader();
				_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoadComplete);
				_swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
				_swfLoader.loadBytes(famFile.swfBytes, loaderConext);
			}
		}
		
		private function onSWFLoadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = (e.target as LoaderInfo);
			var domain:ApplicationDomain = loaderInfo.applicationDomain;
			var tmpDatas:Array = [];
			for (var i:int = 0; i < famFile.count; ++i)
			{
				var cls:Class = LoaderManager.getClassByPathAndDomain(famFile.generateClassName(i), domain);
				var offsetObj:Object = famFile.offsets[i];
				tmpDatas[i] = new PacckageFileData(cls ? new cls() : null, -offsetObj.cx, -offsetObj.cy);
			}
			
			famFile.datasList = tmpDatas;
			isError = false;
			clearSWFLoader();
			doCallback();
		}
		
		private function onIOErrorHandler(e:IOErrorEvent):void
		{
			isError = true;
			clearSWFLoader();
			famFile = null;
			doCallback();
		}
		
		private function clearSWFLoader():void
		{
			if (_swfLoader)
			{
				_swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSWFLoadComplete);
				_swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
				_swfLoader.unload();
				_swfLoader = null;
			}
		}
		
		private function addCallback(callback:Function):void
		{
			if (!callback)
				return;
			
			if (!_callbackList)
				_callbackList = [callback];
			else if (_callbackList.indexOf(callback) == -1)
				_callbackList.push(callback);
		}
		
		private function doCallback():void
		{
			if (_callbackList)
			{
				for (var i:int = 0; i < _callbackList.length; ++i)
				{
					var callback:Function = _callbackList[i];
					if (callback != null)
						callback(famFile);
				}
			}
			_callbackList = null;
		}
		
		public function dispose():void
		{
			clearSWFLoader();
		}
		
	}
}