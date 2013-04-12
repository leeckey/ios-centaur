package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   普通攻击操作
	 */ 
	public final class AttackEffectAction extends ActionBase
	{

		function AttackEffectAction()
		{
			type = ACTION_ATTACK_EFFECT;
		}
		
		public static function getAction(srcID:uint, targetID:uint):AttackEffectAction
		{
			var action:AttackEffectAction = new AttackEffectAction();
			action.srcObj = srcID;
			action.targetObj = targetID;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return srcObj + "普通攻击" + targetObj;
		}
	}
}