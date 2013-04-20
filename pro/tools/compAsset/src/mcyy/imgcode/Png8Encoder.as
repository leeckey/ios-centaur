package mcyy.imgcode
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.graphics.codec.PNGEncoder;
	
	public class Png8Encoder extends EventDispatcher
	{
		public static const COMPLETE:String = "COMPLETE";
		public static const ERROR:String = "ERROR";

		private var _oriBmpData:BitmapData;
		private var _seq:int = 0;
		private var _cx:int=0;
		private var _cy:int=0;
		private var _rw:int=0;
		private var _rh:int=0;
		
		private var _png8ByteArray:ByteArray;
		
		public function Png8Encoder( bd:BitmapData=null , seq:int=0 )
		{
			_oriBmpData = bd;
			_seq = seq;
			
			if( bd )
			{
				encode( bd , seq );
			}
		}
		
		public function encode( bd:BitmapData , seq:int=0 , cx:int=0 , cy:int=0 , rw:int=0 , rh:int=0 ) : void
		{
			if( !bd )
			{
				// 参数无效
				this.dispatchEvent( new Event(ERROR) );
				return;
			}
			
			_oriBmpData = bd;
			_seq = seq;
			_cx = cx;
			_cy = cy;
			_rw = rw;
			_rh = rh;
			
			// 先编码成 png32
			var png32Encoder:PNGEncoder = new PNGEncoder();
			var baOri:ByteArray = png32Encoder.encode( _oriBmpData );
			if( !baOri )
			{
				// png32编码失败
				this.dispatchEvent( new Event(ERROR) );
				return;
			}
			
			// OK,保存成临时文件
			var swfStream:FileStream = new FileStream();
			var filePng : File = File.applicationStorageDirectory;// File.applicationDirectory;
			filePng = filePng.resolvePath("temp"+_seq+".png");
			
			swfStream.open( /*new File("C:\\Temp\\temp.png" )*/  filePng , FileMode.WRITE);			
			swfStream.writeBytes( baOri );			
			swfStream.close();
			
			swfStream = null;			
			
			// 对临时文件temp.png调用 png8 编码
			callPng8EncodeExe( filePng );
		}
		
		private function callPng8EncodeExe( filePng : File ):void
		{
			var np:NativeProcess = new NativeProcess;	
			if( !NativeProcess.isSupported )
			{
				trace( "not supported" );
				Alert.show("NativeProcess not supported");
				return;
			}
			NativeApplication.nativeApplication.autoExit=true;
			
			var file : File = File.applicationDirectory;
			file = file.resolvePath("bin/png8.exe");
			nativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = file;
			
			var exeStr:String = file.url;
			
			var arguments:Vector.<String> = nativeProcessStartupInfo.arguments;
			arguments[0] = "-force";
			arguments[1] = "256";
			arguments[2] = filePng.nativePath;
			
			nativeProcessStartupInfo.arguments = arguments;
			
			var nativeProcessStartupInfo:NativeProcessStartupInfo;
			
			//np.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData); 
			np.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData); 
			np.addEventListener(NativeProcessExitEvent.EXIT, onPng8ExeExit); 
			np.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError); 
			np.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);                		
			
			np.start(nativeProcessStartupInfo);
			trace( "call png8 encode exe ok" );
			
		}
		
		
		private function onOutputData(event:ProgressEvent):void 
		{ 
			//trace("Got: ", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
		} 
		private function onErrorData(event:ProgressEvent):void 
		{ 
			trace("ERROR -" ); 
			this.dispatchEvent( new Event(ERROR) );
		} 
		
		private function onPng8ExeExit(event:NativeProcessExitEvent):void 
		{ 
			if( event.exitCode )
			{
				// 失败
				trace("Process exited with ", event.exitCode); 
				this.dispatchEvent( new Event(ERROR) );
				return;
			}
			
			// 转换完成 , 从文件 temp-fs8.png 中读回文件数据
			var filePng : File = File.applicationStorageDirectory;
			filePng = filePng.resolvePath("temp"+_seq+"-fs8.png" /*"temp-fs8.png"*/);
			var pngDataLoader:PngLoader = new PngLoader( filePng.url , _seq );
			pngDataLoader.addEventListener(ImageLoader.COMPLETE, onPngDataLoadComplete);
			pngDataLoader.addEventListener(ImageLoader.ERROR, onIOError);
			
			pngDataLoader.load();
		} 
		
		private function onPngDataLoadComplete( evt:Event ):void
		{
			var pngLoader:PngLoader = evt.target as PngLoader;
			
			_png8ByteArray = pngLoader.bitmapData;
			
			// OK 
			
			// 删除临时文件
			var filePng : File = File.applicationStorageDirectory;
			filePng = filePng.resolvePath("temp"+_seq+"-fs8.png");
			//filePng.deleteFile();
			
			filePng = filePng.resolvePath("temp"+_seq+".png");
			//filePng.deleteFile();
			
			var timer:Timer = new Timer( 1500 , 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE , onDelTempFileTimer );
			timer.start();
			// 发布结束事件
			this.dispatchEvent( new Event(COMPLETE) );
		}
		
		private function onDelTempFileTimer( evt:TimerEvent ):void
		{
			var timer:Timer = evt.target as Timer;
			if( timer )
			{
				timer.stop();
			}
			// 删除临时文件
			var filePng : File = File.applicationStorageDirectory;
			filePng = filePng.resolvePath("temp"+_seq+"-fs8.png");
			filePng.deleteFile();
			
			filePng = File.applicationStorageDirectory.resolvePath("temp"+_seq+".png");
			filePng.deleteFile();
		}
		
		private function onIOError(event:IOErrorEvent):void 
		{ 
			trace(event.toString()); 
			this.dispatchEvent( new Event(ERROR) );
		} 
		
		public function get seq():int{
			return _seq;
		}
		
		public function get bitmapData():ByteArray{
			return _png8ByteArray;
		}
		
		public function get cx():int{
			return _cx;
		}
		
		public function get cy():int{
			return _cy;
		}
		
		public function get rw():int{
			return _rw;
		}
		
		public function get rh():int{
			return _rh;
		}
	}
	
}