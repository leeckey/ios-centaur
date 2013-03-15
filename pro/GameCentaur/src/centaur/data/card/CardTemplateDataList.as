package centaur.data.card
{
	import centaur.utils.Utils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public final class CardTemplateDataList
	{
		private static var _cardDic:Dictionary = new Dictionary();
		
		public static function getCardData(templateID:uint):CardTemplateData
		{
			return _cardDic[templateID];
		}
		
		public static function loadData(data:ByteArray):void
		{
			//
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
				
				var cardTemplateData:CardTemplateData = new CardTemplateData();
				Utils.initStrDataToObjectData(cardTemplateData, dataStr, format);
				
				if (cardTemplateData.templateID > 0)
					_cardDic[cardTemplateData.templateID] = cardTemplateData;
			}
		}
		
	}
}