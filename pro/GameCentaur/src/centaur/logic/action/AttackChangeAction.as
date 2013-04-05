package centaur.logic.action
{
	public class AttackChangeAction extends ActionBase
	{	
		/**
		 * 变化数量 
		 */		
		public var num:int;
		
		public function AttackChangeAction()
		{
			type = ACTION_ATTACK_CHANGE;
		}
		
		public static function getAction(srcID:uint, num:int):AttackChangeAction
		{
			var action:AttackChangeAction = new AttackChangeAction();
			action.srcObj = srcID;
			action.num = num;
			
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
			return srcObj +"攻击力变化了"+ num;
		}
	}
}