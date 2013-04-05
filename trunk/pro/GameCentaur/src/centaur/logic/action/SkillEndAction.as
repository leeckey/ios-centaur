package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;
	
	/**
	 * 技能施放结束 
	 * @author minnie
	 * 
	 */	
	public class SkillEndAction extends ActionBase
	{	
		/**
		 * 技能ID 
		 */		
		public var skillID:uint;
		
		public function SkillEndAction()
		{
			type = ACTION_SKILL_END;
		}
		
		public static function getAction(srcID:uint, skillID:uint):SkillEndAction
		{
			var action:SkillEndAction = new SkillEndAction();
			action.srcObj = srcID;
			action.skillID = skillID;
			
			trace(action.toString());
			return action;
		}
		
		/**
		 * 描述信息 
		 * @return 
		 * 
		 */		
		public override function toString():String
		{
			return srcObj +"释放"+ skillID + "技能结束";
		}
	}
}