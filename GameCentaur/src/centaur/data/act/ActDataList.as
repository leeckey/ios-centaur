package centaur.data.act
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public final class ActDataList
	{
		private static var _actDic:Dictionary = new Dictionary();
		
		public static function loadData(data:ByteArray):void
		{
			//
		}
		
		public static function getActData(templateID:uint):ActData
		{
			return _actDic[templateID];
		}
	}
}