package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.AttackChangeAction;
	import centaur.utils.UniqueNameFactory;

	public final class AttackChangeHandler extends ActionHandler
	{
		public function AttackChangeHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:AttackChangeAction = action as AttackChangeAction;
			if (!actionData)
				return;
			
			var target:BaseCardObj = UniqueNameFactory.UniqueObjDic[actionData.srcObj];
			if (!target)
				return;
			
			if (target.render)
			{
				target.render.handleAttackChange(actionData.num);
			}
		}
	}
}