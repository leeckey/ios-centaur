package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	public final class DamageNotifyAction extends ActionBase
	{
		public var damage:int;
		
		public function DamageNotifyAction()
		{
			type = ACTION_DAMAGE_NOTIFY;
		}
		
		public static function getAction(damage:int, targetID:uint):DamageNotifyAction
		{
			var action:DamageNotifyAction = new DamageNotifyAction();
			action.damage = damage;
			action.targetObj = targetID;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return targetObj + "受到" + damage + "伤害";
		}
	}
}