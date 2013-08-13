package centaur.logic.action
{
	public class MaxHpChangeAction extends ActionBase
	{
		/**
		 * 最大血量变化
		 */		
		public var maxHpChange:int;
		
		public var hpChange:int;
		
		public function MaxHpChangeAction()
		{
			super();
		}
		
		public static function getAction(maxHp:int, hp:int, targetID:uint):MaxHpChangeAction
		{
			var action:MaxHpChangeAction = new MaxHpChangeAction();
			action.maxHpChange = maxHp;
			action.hpChange = hp;
			action.targetObj = targetID;
			
			trace(action.toString());
			return action;
		}
		
		public override function toString():String
		{
			return targetObj + "最大血量变化" + maxHpChange;
		}
	}
}