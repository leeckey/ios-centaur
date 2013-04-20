package centaur.logic.action
{
	public class CureNotifyAction extends ActionBase
	{
		/**
		 * 治疗血量 
		 */		
		public var cure:int;
		
		public function CureNotifyAction()
		{
			type = ACTION_CURE_NOTIFY;
		}
		
		public static function getAction(cure:int, targetID:uint):CureNotifyAction
		{
			var action:CureNotifyAction = new CureNotifyAction();
			action.cure = cure;
			action.targetObj = targetID;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return targetObj + "治疗增加血量:" + cure;
		}
	}
}