package mcyy.loader.fanim
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	

	public class AlphaJpegFrameAssemble extends EventDispatcher
	{
		public static const COMPLETE:String = "COMPLETE";
		public static const ERROR:String = "ERROR";
		
		private var _loader:Loader;
		
		private var _bitmapdata:BitmapData;					// 图像数据
		private var _rect:Rectangle;							// 注册点和w/h
		
		private var _jpegData:ByteArray ;
		private var _alphaData:ByteArray;
		
		private var _iIdx:uint = 0;
		
		public function AlphaJpegFrameAssemble( iIdx:uint=0 )
		{
			_iIdx = iIdx;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		public function get iIdx() : uint
		{
			return _iIdx;
		}
		
		public function load( jpegData:ByteArray , alphaData:ByteArray ):Boolean
		{
			if( jpegData==null )
				return false;
			
			_jpegData = jpegData;
			_alphaData = alphaData;
			
			_loader.loadBytes( _jpegData );
			return true;
		}
		
		private function onComplete(evt:Event):void
		{
			var  _bitmap:Bitmap = LoaderInfo(evt.target).content as Bitmap;
			_bitmapdata = _bitmap.bitmapData;
			
			//  assert _bitmapdata.w * h == _alphaData.length
			/*var newData : ByteArray = new ByteArray();
			newData.length = _alphaData.length * 4;
			for( var i:uint = 0; i<_alphaData.length; ++i )
			{
				newData[i*4] = _alphaData[i];
			}*/
			
			var rectSet:Rectangle = new Rectangle(0,0,_bitmapdata.width , _bitmapdata.height);
			var oriBmpData:ByteArray = new ByteArray();// _bitmapdata.getPixels( rectSet );
			var alphaSz:uint = _alphaData.length;
			oriBmpData.length = alphaSz << 2;
			for( var i:uint = 0; i<alphaSz; ++i )
			{
				oriBmpData[i<<2] = _alphaData[i];
			}

			oriBmpData.position = 0;
			if (alphaSz != 0)
			{
				var newBmpData:BitmapData = new BitmapData( _bitmapdata.width , _bitmapdata.height , true , 0 );
				newBmpData.setPixels( rectSet , oriBmpData );
				newBmpData.copyPixels( _bitmapdata , rectSet , new Point(0,0) , newBmpData , new Point(0,0) , false );
				_bitmapdata = newBmpData;								// 组合后的BitmapData
			}
			
			// 发布结束事件
			this.dispatchEvent(new Event(COMPLETE));
		}
		
		private function onError(evt:Event):void
		{
			this.dispatchEvent(new Event(ERROR));
		}
		
		public function unload():void{
			_loader.unload();
			_loader = null;
			_bitmapdata.dispose();
			_bitmapdata = null;
			
			_jpegData = null;
			_alphaData = null;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapdata;
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function set rect( rc:Rectangle ): void
		{
			_rect = rc;
		}
	}
}