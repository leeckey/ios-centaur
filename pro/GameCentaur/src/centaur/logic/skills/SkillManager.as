package centaur.logic.skills
{
	
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
		private var skillClass:Array= [ Skill_101, Skill_102, Skill_200, Skill_201, Skill_202, Skill_203, Skill_103 ];
		
		public static function init():void
		{
			
		}
	}
}