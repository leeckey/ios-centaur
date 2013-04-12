package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.SelectCardToCemeteryArea;
	import centaur.utils.UniqueNameFactory;

	/**
	 *   处理添加卡牌到墓地的操作
	 *   @author wangq 2013.04.12
	 */ 
	public final class CardToCemeteryAreaHandler extends ActionHandler
	{
		public function CardToCemeteryAreaHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:SelectCardToCemeteryArea = action as SelectCardToCemeteryArea;
			if (!actionData)
				return;
			
			var cardObj:BaseCardObj = UniqueNameFactory.UniqueObjDic[actionData.cardID] as BaseCardObj;
			if (!cardObj)
				return;
			
			CombatPanel.instance.addCardToCemeteryArea(actionData.srcObj, cardObj);
		}
	}
}