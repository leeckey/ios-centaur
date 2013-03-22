package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	public final class DamageNotifyAction extends ActionBase
	{
		public var damage:int;
		
		public function DamageNotifyAction()
		{
			type = CombatLogic.ACTION_DAMAGE_NOTIFY;
		}
		
		public static function addDamageAction(damage:int, targetID:uint):DamageNotifyAction
		{
			var action:DamageNotifyAction = new DamageNotifyAction();
			action.damage = damage;
			action.targetObj = targetID;
			
			return action;
		}
	}
}