package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	

	public class PngLoader extends EventDispatcher
	{
		public static const COMPLETE:String = "COMPLETE";
		public static const ERROR:String = "ERROR";
		
		private var _loader:URLLoader;

		private var _bitmapdata:ByteArray;
		private var _seq:int;
		private var _url:String;

		// for fam png8 loader
		private var _pngloader:Loader;
		private var _bd:BitmapData;							// 图像数据
		private var _rect:Rectangle;							// 注册点和w/h
		
		public function PngLoader(url:String,seq:int=0)
		{
			_url = url
			_seq = seq;
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);

			_pngloader = new Loader();
			_pngloader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDataComplete);
			_pngloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onDataError);
		}
		
		public function load():void{
			_loader.load(new URLRequest(_url));
		}
		
		private function onComplete(evt:Event):void{
			_bitmapdata = evt.target.data;
			this.dispatchEvent(new Event(COMPLETE));
		}
		
		private function onError(evt:Event):void{
			this.dispatchEvent(new Event(ERROR));
		}
		
		public function loadFromData( pngData:ByteArray ):Boolean
		{
			if( pngData==null )
				return false;
			_pngloader.loadBytes( pngData );
			pngData = null;
			return true;
		}
		
		private function onDataComplete(evt:Event):void
		{
			var  _bitmap:Bitmap = LoaderInfo(evt.target).content as Bitmap;
			_bd = _bitmap.bitmapData;
			
			// 发布结束事件
			this.dispatchEvent(new Event(COMPLETE));
		}
		
		private function onDataError(evt:Event):void
		{
			this.dispatchEvent(new Event(ERROR));
		}
		
		public function unload():void{
			_loader = null;
			_bitmapdata = null;
			_seq = 0;
		}
		
		public function get seq():int{
			return _seq;
		}
		
		public function get bitmapData():ByteArray{
			return _bitmapdata;
		}
		
		public function get bd():BitmapData
		{
			return _bd;
		}
		
		public function get url():String{
			return _url;
		}
		
		public function set rect( rc:Rectangle ):void
		{
			_rect = rc;
		}
		
		public function get rect() : Rectangle
		{
			return _rect;
		}
	}
}