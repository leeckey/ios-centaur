package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	public final class SkillEffectAction extends ActionBase
	{
		public var skillID:uint;
		public var targetList:Array;
		
		public function SkillEffectAction()
		{
			type = CombatLogic.ACTION_SKILL_EFFECT;
		}
		
		public static function addSkillEffect(srcID:uint, targetID:uint, skillID:uint, targetList:Array):SkillEffectAction
		{
			var action:SkillEffectAction = new SkillEffectAction();
			action.srcObj = srcID;
			action.targetObj = targetID;
			action.skillID = skillID;
			action.targetList = targetList;
			
			return action;
		}
	}
}