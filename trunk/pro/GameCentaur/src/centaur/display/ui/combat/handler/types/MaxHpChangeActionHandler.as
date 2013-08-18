package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.MaxHpChangeAction;
	import centaur.logic.render.BaseCardRender;
	import centaur.utils.UniqueNameFactory;

	/**
	 *   最大血量变化处理
	 */ 
	public final class MaxHpChangeActionHandler extends ActionHandler
	{
		public function MaxHpChangeActionHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:MaxHpChangeAction = action as MaxHpChangeAction;
			if (!actionData)
				return;
			
			var maxHPChangeObj:* = UniqueNameFactory.UniqueObjDic[actionData.targetObj];
			if (maxHPChangeObj is BaseCardObj)
			{
				var cardRender:BaseCardRender = (maxHPChangeObj as BaseCardObj).render;
				cardRender.handleHPChange(-actionData.maxHpChange);
			}
			else if (maxHPChangeObj is BaseActObj)
			{
				
			}
		}
	}
}