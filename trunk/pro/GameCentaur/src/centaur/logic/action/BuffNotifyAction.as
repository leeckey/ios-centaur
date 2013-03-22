package centaur.logic.action
{
	import centaur.data.buff.BuffData;
	import centaur.logic.combat.CombatLogic;

	public final class BuffNotifyAction extends ActionBase
	{
		public static const BUFF_ADD_ACTION:int = 0;
		public static const BUFF_REMOE_ACTION:int = 1;
		
		public var buffData:BuffData;
		public var actionType:int;
		
		public function BuffNotifyAction()
		{
			type = CombatLogic.ACTION_BUFF_NOTIFY;
		}
		
		public static function addBuffAction(buffData:BuffData, targetID:uint, actionType:int = BUFF_ADD_ACTION):BuffNotifyAction
		{
			var action:BuffNotifyAction = new BuffNotifyAction();
			action.buffData = buffData;
			action.targetObj = targetID;
			action.actionType = actionType;
			
			return action;
		}
	}
}