package mcyy.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mcyy.loader.fanim.FamFileWrite;
	import mcyy.loader.fanim.FanmFileInfo;

	/**
	 *   批量转换文件夹下fam的帧率帧频参数的处理器
	 *   @author wangq 2012.10.20
	 */ 
	public final class BatImplFrameInfoHandler extends EventDispatcher
	{
		private var _inputDir:File;		// 输入目录
		private var _outputDir:File;	// 输出目录
		
		private var _filters:Array;		// 文件名过滤表
		private var _frameType:int;		// 最新帧频参数
		private var _frameRate:int;		// 最新帧率参数
		private var _isList5Direct:Boolean;
		
		private var _famFileList:Array = [];	// 输入目录中所有的fam文件名称
		private var _totalCount:int;			// 处理文件总数
		private var _currentFamFile:File;		// 当前处理的fam文件
		private var _onlyUpdateFam:Boolean;		// 只是更新到Fam最新版，不处理其他
		
		public function BatImplFrameInfoHandler(inputDir:File, outputDir:File, filters:Array, frameType:int, frameRate:int, isList5Direct:Boolean, OnlyUpdateFam:Boolean)
		{
			_inputDir = inputDir;
			_outputDir = outputDir;
			_filters = filters;
			_frameType = frameType;
			_frameRate = frameRate;
			_isList5Direct = isList5Direct;
			_onlyUpdateFam = OnlyUpdateFam;
		}
		
		public function start():void
		{
			FileUtils.getAllSpecificFiles(_inputDir, _famFileList, ".fam");
			_totalCount = _famFileList.length;
			
			handleNext();
		}
		
		public function get totalCount():int
		{
			return _totalCount;
		}
		
		public function get handledCount():int
		{
			return _totalCount - _famFileList.length;
		}
		
		public function get currentFamFile():File
		{
			return _currentFamFile;
		}
		
		private function handleNext():void
		{
			if (_famFileList.length == 0)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			_currentFamFile = _famFileList.pop();
			if (!_currentFamFile)
			{
				handleNext();
				return;
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, this.famLoadCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.famIoErrorHandler);
			urlLoader.load( new URLRequest( _currentFamFile.nativePath ) );
		}
		
		
		private function famLoadCompleteHandler( event:Event ) : void
		{
			var urlLoader:URLLoader = URLLoader( event.target );
			
			if (_currentFamFile)
			{
				var famInfo:FanmFileInfo = new FanmFileInfo();
				famInfo.datas = urlLoader.data;
				urlLoader.close();
				
				// 通过过滤器的,需要更新修改帧率等相关参数
				if (!_onlyUpdateFam)
				{
					var checkFilter:Boolean = checkFilter(_currentFamFile.name);
					if (checkFilter)
					{
						famInfo.frameRate = _frameRate;
						if (famInfo.frameType != _frameType)
						{
							// 自动更新帧
							famInfo.frameType = _frameType;
							famInfo.updateFrames();
						}
					}
					
					var currDirect5:Boolean = famInfo.isDirect5 || ((famInfo.frames.length % 5) == 0);
					if (_isList5Direct == currDirect5)
					{
						this.dispatchEvent(new Event(Event.SELECT));
					}
				}
				
				var relativePath:String = _inputDir.getRelativePath(_currentFamFile);
				var writeFile:File = _outputDir.resolvePath(relativePath);
				FamFileWrite.writeFamFile(famInfo, writeFile.nativePath);
			}
			
			_currentFamFile = null;
			handleNext();
		}
		
		private function famIoErrorHandler( event:IOErrorEvent ) : void
		{
			handleNext();
		}
		
		/**
		 *   文件过滤 true表示通过，false表示需要被过滤掉
		 */ 
		private function checkFilter(path:String):Boolean
		{
			if ((!_filters) || (_filters.length == 0))
				return true;
				
			var length:int = _filters.length;
			for (var i:int = 0; i < length; ++i)
			{
				var filterStr:String = _filters[i];
				if (filterStr && (path.indexOf(filterStr) != -1))
					return false;
			}
			
			return true;
		}
	}
}