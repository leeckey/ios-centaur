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
		private var skillClass:Array= [ Skill_99, Skill_101, Skill_102, Skill_103, Skill_104, Skill_200, Skill_201, Skill_202, Skill_203, Skill_204, Skill_100 ];
		
		private var buffCladd:Array = [ Buff_100, Buff_101, Buff_102 ];
		
		public static function init():void
		{
			
		}
	}
}