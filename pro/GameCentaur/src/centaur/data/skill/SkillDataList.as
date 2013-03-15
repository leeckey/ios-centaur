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
		
		public static function getSkillTemplateData(templateID:uint):SkillData
		{
			return _skillDic[templateID];
		}
		
		public static function loadStrData(str:String):void
		{
			
		}
	}
}