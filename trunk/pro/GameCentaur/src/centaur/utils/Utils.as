package centaur.utils
{
	public final class Utils
	{
		public static const EMPTY_ARRAY:Array = [];
		
		public static function toUint(arr:Array):void
		{
			if (!arr)
				return;
			
			var len:int = arr.length;
			for (var i:int = 0; i < len; ++i)
				arr[i] = uint(arr[i]);
		}
		
		public static function initStrDataToObjectData(dataObj:Object, str:String, format:Array):void
		{
			if (!dataObj || !str)
				return;
			
			var propertyList:Array = str.split("\t");
			var len:int = propertyList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var propertyName:String = format[i];
				var propertyValue:String = propertyList[i];
				if (!propertyName || !propertyValue)
					continue;
				
				if (!dataObj.hasOwnProperty(propertyName))
					continue;
				
				if (dataObj[propertyName] is Array)
				{
					var arr:Array = propertyValue.split(",");
					Utils.toUint(arr);
					dataObj[propertyName] = arr;
				}
				else
					dataObj[propertyName] = propertyValue;
			}
		}
	}
}