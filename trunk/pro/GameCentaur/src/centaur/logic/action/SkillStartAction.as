package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 * 开始施放技能 
	 * @author minnie
	 * 
	 */	
	public final class SkillStartAction extends ActionBase
	{
		/**
		 * 技能ID 
		 */		
		public var skillID:uint;
		
		/**
		 * 技能作用目标 
		 */		
		public var targets:Array;
		
		public function SkillStartAction()
		{
			type = ACTION_SKILL_START;
		}
		
		public static function getAction(srcID:uint, skillID:uint, targetList:Array):SkillStartAction
		{
			var action:SkillStartAction = new SkillStartAction();
			action.srcObj = srcID;
			action.targets = targetList;
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
			var temp:String = " ";
			for	(var i:int = 0; i < targets.length; i++)
			{
				temp += targets[i] + " ";
			}

			return srcObj + "给目标" + temp + "释放了"+ skillID + "技能";
		}
	}
}