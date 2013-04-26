package centaur.loader
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public final class BitmapDataManager
	{
		private var _dataDic:Dictionary = new Dictionary();
		
		public function BitmapDataManager()
		{
		}
		
		public function getBitmapData(path:String, callback:Function):void
		{
			if (!path)
				return;
			
			var data:BitmapDataCounter = _dataDic[path] as BitmapDataCounter;
			if (!data)
			{
				data = _dataDic[path] = new BitmapDataCounter();
				data.load(path, callback);
			}
			else
				data.addCallback(callback);
		}
		
		public function removeBitmapData(path:String):void
		{
			if (!path)
				return;
			
			var data:BitmapDataCounter = _dataDic[path] as BitmapDataCounter;
			if (data && data.dispose())
				delete _dataDic[path];
		}
	}
}
import centaur.data.GlobalAPI;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.utils.ByteArray;

class BitmapDataCounter
{
	public var bitmapData:BitmapData;
	private var _count:int;
	
	private var _picLoader:Loader;
	private var _callbacks:Array;
	
	public function BitmapDataCounter()
	{
		_callbacks = [];
	}
	
	public function load(url:String, callback:Function = null):void
	{
		if (bitmapData)
		{
			if (callback != null)
				callback(bitmapData);
			return;
		}
		
		addCallback(callback);
		var bytes:ByteArray = GlobalAPI.loaderManager.loadByteArray(url);
		if (!bytes)
			return;
		
		_picLoader = new Loader();
		_picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		_picLoader.loadBytes(bytes);
	}
	
	private function onComplete(e:Event):void
	{
		_picLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
		this.bitmapData = (_picLoader.content as Bitmap).bitmapData;
		_picLoader.unload();
		_picLoader = null;
		
		// 资源加载完成，处理所有监听回调
		callbackAll();
	}
	
	public function addCallback(callback:Function):void
	{
		if (bitmapData)
		{
			if (callback != null)
				callback(bitmapData);
		}
		else
		{
			if (callback != null && _callbacks.indexOf(callback) == -1)
				_callbacks.push(callback);
		}
		_count++;
	}
	
	private function callbackAll():void
	{
		if (bitmapData)
		{
			var len:int = _callbacks.length;
			for (var i:int = 0; i < len; ++i)
			{
				var func:Function = _callbacks[i] as Function;
				if (func != null)
					func(bitmapData);
			}
			_callbacks.length = 0;
		}
	}
	
	public function dispose():Boolean
	{
		_count--;
		if (_count > 0)		// 还存在引用，不准析构
			return false;
		
		_count = 0;
		if (bitmapData)
			bitmapData.dispose();
		bitmapData = null;
		
		return true;
	}
}