package centaur.data.skill
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public final class SkillDataList
	{
		private static var _skillDic:Dictionary = new Dictionary();
		
		public static function loadData(data:ByteArray):void
		{
			//
		}
		
		public static function getCardData(templateID:uint):SkillData
		{
			return _skillDic[templateID];
		}
	}
}