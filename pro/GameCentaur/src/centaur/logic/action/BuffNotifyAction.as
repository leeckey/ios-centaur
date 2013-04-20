package centaur.logic.action
{
	import centaur.data.buff.BuffData;
	import centaur.logic.combat.CombatLogic;

	public final class BuffNotifyAction extends ActionBase
	{
		public static const BUFF_ADD_ACTION:int = 0;
		public static const BUFF_REMOVE_ACTION:int = 1;
		
		public var buffID:int;
		public var actionType:int;
		
		public function BuffNotifyAction()
		{
			type = ACTION_BUFF_NOTIFY;
		}
		
		public static function getAction(buffID:int, targetID:uint, actionType:int = BUFF_ADD_ACTION):BuffNotifyAction
		{
			var action:BuffNotifyAction = new BuffNotifyAction();
			action.buffID = buffID;
			action.targetObj = targetID;
			action.actionType = actionType;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			if (actionType == BUFF_ADD_ACTION)
				return "卡牌" + targetObj  + "的buffID" + buffID + "增加了";
			else
				return  "卡牌" + targetObj + "的buffID" + buffID + "消失了" ;
		}
	}
}