package centaur.display.ui.combat.handler.types
{
	import centaur.data.buff.BuffData;
	import centaur.data.buff.BuffDataList;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.utils.UniqueNameFactory;

	public final class BuffNotifyHandler extends ActionHandler
	{
		public function BuffNotifyHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:BuffNotifyAction = action as BuffNotifyAction;
			if (!actionData)
				return;
			
			var target:BaseCardObj = UniqueNameFactory.UniqueObjDic[actionData.targetObj];
			if (!target)
				return;
			 
			if (target.render)
			{
				if (actionData.actionType == BuffNotifyAction.BUFF_ADD_ACTION)
					target.render.addBuff(actionData.buffID);
				else if (actionData.actionType == BuffNotifyAction.BUFF_REMOVE_ACTION)
					target.render.removeBuff(actionData.buffID);
			}
		}
	}
}