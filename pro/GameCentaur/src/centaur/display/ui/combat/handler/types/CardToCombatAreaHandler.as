package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.CombatActPanel;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.SelectCardToCombatAreaAction;
	import centaur.utils.UniqueNameFactory;

	/**
	 *   处理添加卡牌到战斗区的操作
	 *   @author wangq 2013.04.12
	 */ 
	public final class CardToCombatAreaHandler extends ActionHandler
	{
		public function CardToCombatAreaHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:SelectCardToCombatAreaAction = action as SelectCardToCombatAreaAction;
			if (!actionData)
				return;
			
			var cardObj:BaseCardObj = UniqueNameFactory.UniqueObjDic[actionData.cardID] as BaseCardObj;
			if (!cardObj)
				return;
			
			CombatPanel.instance.addCardToCombatArea(actionData.srcObj, cardObj);
		}
	}
}