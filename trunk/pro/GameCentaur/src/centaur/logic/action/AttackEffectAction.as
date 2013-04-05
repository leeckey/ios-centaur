package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   普通攻击操作
	 */ 
	public final class AttackEffectAction extends ActionBase
	{
		public var targetList:Array;	// 普通攻击的目标列表
		public var atkSkillID:uint;		// 普通攻击效果
		
		function AttackEffectAction()
		{
			type = ACTION_ATTACK_EFFECT;
		}
		
		public static function getAction(srcID:uint, targetID:uint, targetList:Array = null, atkSkillID:uint = 0):AttackEffectAction
		{
			var action:AttackEffectAction = new AttackEffectAction();
			action.srcObj = srcID;
			action.targetObj = targetID;
			action.targetList = targetList;
			action.atkSkillID = atkSkillID;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return srcObj + "普通攻击" + targetObj;
		}
	}
}