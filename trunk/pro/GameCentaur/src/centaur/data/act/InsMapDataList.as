package centaur.data.act
{
	import centaur.utils.Utils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public final class InsMapDataList
	{
		private static var _insMapDic:Dictionary = new Dictionary();
		
		public function InsMapDataList()
		{
		}
		
		public static function getInsMapData(templateID:uint):InsMapData
		{
			return _insMapDic[templateID];
		}
		
		public static function loadData(bytes:ByteArray):void
		{
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
				
				var insMapData:InsMapData = new InsMapData();
				Utils.initStrDataToObjectData(insMapData, dataStr, format);
				
				if (insMapData.templateID > 0)
					_insMapDic[insMapData.templateID] = insMapData;
			}
		}
		
	}
}