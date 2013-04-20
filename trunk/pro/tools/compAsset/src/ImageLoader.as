package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	

	public class ImageLoader extends EventDispatcher
	{
		public static const COMPLETE:String = "COMPLETE";
		public static const ERROR:String = "ERROR";
		
		private var _loader:Loader;

		private var _bitmapdata:BitmapData;
		private var _seq:int;
		private var _url:String;
		
		public function ImageLoader(url:String,seq:int=0)
		{
			_url = url
			_seq = seq;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		public function load():void{
			_loader.load(new URLRequest(_url), new LoaderContext());
		}
		
		private function onComplete(evt:Event):void{
			var  _bitmap:Bitmap = LoaderInfo(evt.target).content as Bitmap;
			_bitmapdata = _bitmap.bitmapData;
			this.dispatchEvent(new Event(COMPLETE));
		}
		
		private function onError(evt:Event):void{
			this.dispatchEvent(new Event(ERROR));
		}
		
		public function unload():void{
			_loader.unload();
			_loader = null;
			_bitmapdata.dispose();
			_bitmapdata = null;
			_seq = 0;
		}
		
		public function get seq():int{
			return _seq;
		}
		
		public function get bitmapData():BitmapData{
			return _bitmapdata;
		}
		
		public function get url():String{
			return _url;
		}
	}
}