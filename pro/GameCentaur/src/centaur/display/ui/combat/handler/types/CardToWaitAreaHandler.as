package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.CombatActPanel;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.SelectCardToCemeteryArea;
	import centaur.logic.action.SelectCardToWaitAreaAction;
	import centaur.utils.UniqueNameFactory;

	/**
	 *   处理添加卡牌到等待区的操作
	 * 	 @author wangq 2013.04.12
	 */ 
	public final class CardToWaitAreaHandler extends ActionHandler
	{
		public function CardToWaitAreaHandler(action:ActionBase)
		{
			super(action);
		}
		
		/**
		 *  将卡牌添加到等待区域
		 */ 
		override public function doHandler():void
		{
			var actionData:SelectCardToWaitAreaAction = action as SelectCardToWaitAreaAction;
			if (!actionData)
				return;
			
			var cardObj:BaseCardObj = UniqueNameFactory.UniqueObjDic[actionData.cardID] as BaseCardObj;
			if (!cardObj)
				return;
			
			CombatPanel.instance.addCardToWaitArea(actionData.srcObj, cardObj);
		}
	}
}