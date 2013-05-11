package centaur.data.buff
{
	import centaur.utils.Utils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * buff配置表 
	 * @author liq
	 * 
	 */	
	public final class BuffDataList
	{
		
		private static var _buffDic:Dictionary = new Dictionary();
		
		public static function loadData(data:ByteArray):void
		{
			//
		}
		
		public static function getBuffData(id:uint):BuffData
		{
			return _buffDic[id];
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
				
				var buffData:BuffData = new BuffData();
				Utils.initStrDataToObjectData(buffData, dataStr, format);
				
				if (buffData.id > 0)
					_buffDic[buffData.id] = buffData;
			}
		}
	}
}