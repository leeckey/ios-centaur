package centaur.logic.skills
{
	import centaur.logic.buff.*;
	/**
	 * 技能初始化管理 
	 * @author liq
	 * 
	 */	
	public class SkillManager
	{
		/**
		 * 引用一下,通过反射创建技能 
		 */		
		private var skillClass:Array= [ Skill_99, Skill_100, Skill_101, Skill_102, Skill_103, Skill_104, Skill_105, 
										Skill_106, Skill_107,Skill_108,Skill_109,Skill_110,
										Skill_200, Skill_201, Skill_202, Skill_203, Skill_204, Skill_205, Skill_206, 
										Skill_207, Skill_208, Skill_209, Skill_210, Skill_211, Skill_212, Skill_213,
										Skill_214, Skill_215, Skill_216, Skill_217, Skill_218, Skill_219, Skill_220,
										Skill_221, Skill_222, Skill_223, Skill_224, Skill_225, Skill_226];
		
		private var buffCladd:Array = [ Buff_100, Buff_101, Buff_102 ];
		
		public static function init():void
		{
			
		}
	}
}