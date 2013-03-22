package centaur.data.skill
{
	import centaur.utils.Utils;
	
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
				
				var skillData:SkillData = new SkillData();
				Utils.initStrDataToObjectData(skillData, dataStr, format);
				
				if (skillData.templateID > 0)
					_skillDic[skillData.templateID] = skillData;
			}
		}
	}
}