package centaur.data.card
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public final class CardDataList
	{
		private static var _cardDic:Dictionary = new Dictionary();
		
		public static function loadData(data:ByteArray):void
		{
			//
		}
		
		public static function getCardData(templateID:uint):CardData
		{
			return _cardDic[templateID];
		}
	}
}