package
{
	import centaur.data.GlobalAPI;
	import centaur.data.act.InsMapDataList;
	import centaur.data.card.CardTemplateDataList;
	import centaur.data.skill.SkillDataList;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public final class InitConfig
	{
		public static function initConfig():void
		{
			
			////----wangq  后续真正使用是嵌入到工程中，直接读取二进制即可,目前先读txt，便于配置调试
			
			// 卡牌配置表
			CardTemplateDataList.loadStrData(load("CardTemplateData.txt"));
			
			// 副本配置表
			InsMapDataList.loadStrData(load("InsMapData.txt"));
			
			// 技能配置表
			SkillDataList.loadStrData(load("SkillData.txt"));
		}
		
		private static function load(fileName:String):String
		{
			var path:String = GlobalAPI.pathManager.getConfigPath(fileName);
			var file:File = File.applicationDirectory.resolvePath(path);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, "gbk");
			fileStream.close();
			
			return str;
		}
		
	}
}