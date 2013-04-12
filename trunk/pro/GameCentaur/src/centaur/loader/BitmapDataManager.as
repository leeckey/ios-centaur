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
		
		public function getBitmapData(path:String):BitmapData
		{
			if (!path)
				return null;
			
			var data:BitmapDataCounter = _dataDic[path] as BitmapDataCounter;
			if (!data)
			{
				var cls:Class = LoaderManager.getClassByPathAndDomain(path) as Class;
				var bitmapData:BitmapData = cls ? new cls() as BitmapData : null;
				data = _dataDic[path] = new BitmapDataCounter(bitmapData);
			}
			else
				data.count++;
			
			return data.bitmapData;
		}
	}
}
import flash.display.BitmapData;

class BitmapDataCounter
{
	public var bitmapData:BitmapData;
	public var count:int;
	
	public function BitmapDataCounter(data:BitmapData, count:int = 1)
	{
		this.bitmapData = data;
		this.count = count;
	}
}