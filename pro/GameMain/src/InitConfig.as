package
{
	import centaur.data.GlobalAPI;
	import centaur.data.act.InsMapDataList;
	import centaur.data.buff.BuffDataList;
	import centaur.data.card.CardTemplateDataList;
	import centaur.data.skill.SkillDataList;
	import centaur.logic.skills.SkillManager;
	
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
			
			// BUFF配置表
			BuffDataList.loadStrData(load("BuffData.txt"));
			
			// 初始化技能参数
			SkillManager.init();
		}
		
		private static function load(fileName:String):String
		{
			var path:String = GlobalAPI.pathManager.getConfigPath(fileName);
			return GlobalAPI.loaderManager.loadGBKString(path);
		}
		
	}
}