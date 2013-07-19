package centaur.data.map
{
	import centaur.utils.Utils;
	
	import flash.utils.Dictionary;

	public final class MapDataList
	{
		private static var _mapList:Dictionary = new Dictionary();
		
		public function MapDataList()
		{
		}
		
		public static function getMapData(mapID:uint):MapData
		{
			return _mapList[mapID] as MapData;
		}
		
		public static function loadStrData(str:String):void
		{
			if (!str)
				return;
			
			var dataList:Array = str.split("\r\n");
			var len:int = dataList.length;
			if (len <= 0)
				return;
			
			var format:Array = (dataList[0] as String).split("\t");
			for (var i:int = 2; i < len; ++i)
			{
				var dataStr:String = dataList[i] as String;
				if (!dataStr)
					continue;
				
				var mapData:MapData = new MapData();
				Utils.initStrDataToObjectData(mapData, dataStr, format);
				mapData.init();
				
				if (mapData.templateID > 0)
					_mapList[mapData.templateID] = mapData;
			}
		}
	}
}