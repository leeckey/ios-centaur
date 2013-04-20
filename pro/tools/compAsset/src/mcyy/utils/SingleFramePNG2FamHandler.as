package mcyy.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mcyy.loader.fanim.FamFileWrite;
	import mcyy.loader.fanim.FanmFileInfo;
	
	import mx.controls.Alert;
	
	import spark.utils.BitmapUtil;

	/**
	 *   单帧的PNG转Fam的批量处理器
	 *   @author wangq 2012.11.21
	 */ 
	public final class SingleFramePNG2FamHandler extends EventDispatcher
	{
		private var _files:Array;
		private var _totalCount:int;			// 处理文件总数
		private var _currentFile:File;
		private var _inputDic:File;
		private var _outputDic:File;
		
		private var _paramPF:FanmFileInfo;
		private var _clip:Boolean;
		private var _cx:int;
		private var _cy:int;
		private var _isCompress:Boolean;
		private var _isContainAlpha:int;
		private var _quality:int = 80;
		
		public function SingleFramePNG2FamHandler(files:Array, pf:FanmFileInfo, inputDic:File, outputDic:File, clip:Boolean, quality:int)
		{
			_files = files;
			_paramPF = pf;
			_inputDic = inputDic;
			_outputDic = outputDic;
			_clip = clip;
			_quality = quality;
			_cx = _paramPF.ox;
			_cy = _paramPF.oy;
			_isCompress = _paramPF.isCompress;
			_isContainAlpha = _paramPF.isContainAlpha;
		}
		
		public function start():void
		{
			_totalCount = _files ? _files.length : 0;
			handleNext();
		}
		
		public function get currentFile():File
		{
			return _currentFile;
		}
		
		public function get totalCount():int
		{
			return _totalCount;
		}
		
		public function get handledCount():int
		{
			return _totalCount - _files.length;
		}
		
		private function handleNext():void
		{
			if (!_files || _files.length == 0)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			_currentFile = _files.pop() as File;
			this.dispatchEvent(new Event(Event.CHANGE));
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, this.pngLoadCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.pngIOErrorHandler);
			urlLoader.load( new URLRequest( _currentFile.nativePath ) );
		}
		
		private function pngLoadCompleteHandler(e:Event):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandlerd);
			loader.loadBytes((e.currentTarget as URLLoader).data);
		}
		
		private function completeHandlerd(e:Event):void
		{
			if (!_currentFile)
			{
				handleNext();
				return;
			}
			
			var bitmapData:BitmapData = ((e.currentTarget as LoaderInfo).content as Bitmap).bitmapData;
			var bitmapObject:Object = BitmapUtils.handleBitmapData(bitmapData, _clip, _cx, _cy);
			var jpegTag:Object = BitmapUtils.addImageAssets(bitmapObject.bitmapData, _quality);
			
			var pfInfo:FanmFileInfo = new FanmFileInfo();
			pfInfo.bitmapDatas[0] = jpegTag;
			pfInfo.offsets[0] = { cx:bitmapObject.cx , cy:bitmapObject.cy , rw:bitmapObject.rw , rh:bitmapObject.rh };
			pfInfo.ox = _cx;
			pfInfo.oy = _cy;
			pfInfo.compType = 0;
			pfInfo.count = 1;
			pfInfo.isCompress = _isCompress;
			pfInfo.isContainAlpha = _isContainAlpha;
			pfInfo.frameType = 1;
			
			var writeFile:File;
			if (_inputDic)
			{
				var relativePath:String = _inputDic.getRelativePath(_currentFile);
				writeFile = new File(_outputDic.resolvePath(relativePath).nativePath);
			}
			else
			{
				writeFile = new File(_outputDic.resolvePath(_currentFile.name).nativePath);
			}
			var writePath:String = writeFile.nativePath;
			writePath = writePath.split(".png").join(".fam");
			
			// 写出FanmFile
			FamFileWrite.writeFamFile(pfInfo, writePath);
			
			_currentFile = null;
			handleNext();
		}
		
		private function pngIOErrorHandler(e:IOErrorEvent):void
		{
			Alert.show("加载png错误", "error");
			handleNext();
		}
	}
}