package centaur.data.player
{
	import centaur.utils.Utils;
	
	import flash.utils.Dictionary;

	public final class RoleGrowUpList
	{
		public static var dic:Dictionary = new Dictionary;
		
		public static function getCardData(lv:uint):RoleGrowUpData
		{
			return dic[lv];
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
				
				var growData:RoleGrowUpData = new RoleGrowUpData();
				Utils.initStrDataToObjectData(growData, dataStr, format);
				
				if (growData.lv > 0)
					dic[growData.lv] = growData;
			}
		}
		
	}
}