package centaur.logic.skill
{
	import centaur.data.skill.SkillEnumDefines;
	
	import flash.utils.Dictionary;

	/**
	 *   简单的脚本注册机
	 */ 
	public final class SkillScriptRegister
	{
		public static var scriptDic:Dictionary = new Dictionary();
		public static function register():void
		{
			// 无配置指定脚本，默认类型脚本
			scriptDic[SkillEnumDefines.SKILL2STR[SkillEnumDefines.SKILL_MAGIC_TYPE]] = new MagicSkillHandler();
			scriptDic[SkillEnumDefines.SKILL2STR[SkillEnumDefines.SKILL_ATTACK_TYPE]] = new AttackSkillHandler();
			scriptDic[SkillEnumDefines.SKILL2STR[SkillEnumDefines.SKILL_MAGIC_DEFENSE_TYPE]] = new MagicDefenseSkillHandler();
			scriptDic[SkillEnumDefines.SKILL2STR[SkillEnumDefines.SKILL_ATTACK_DEFENSE_TYPE]] = new AttackDefenseSkillHandler();
			scriptDic[SkillEnumDefines.SKILL2STR[SkillEnumDefines.SKILL_DEATH_TYPE]] = new SpecSkillHandler();
			scriptDic[SkillEnumDefines.SKILL2STR[SkillEnumDefines.SKILL_PRESENT_TYPE]] = new SpecSkillHandler();
			scriptDic[SkillEnumDefines.SKILL2STR[SkillEnumDefines.SKILL_SPEC_DEFENSE_TYPE]] = new SpecDefenseSkillHandler();
		
			// 配置指定脚本
		}
	}
}