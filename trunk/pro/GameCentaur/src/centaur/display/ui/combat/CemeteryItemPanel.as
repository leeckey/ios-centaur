package centaur.display.ui.combat
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;

	/**
	 *   墓地区面板
	 */ 
	public final class CemeteryItemPanel
	{
		public var cemeteryItem:GBase;		// 墓地区格子
		public var cemeteryCardList:Array;	// 墓地区卡牌数据
		
		private var _lastShowItem:DisplayObject;
		
		public function CemeteryItemPanel(cemeteryItem:GBase)
		{
			this.cemeteryItem = cemeteryItem;
			cemeteryCardList = [];
		}
		
		public function addCardToCemeteryArea(cardObj:BaseCardObj):void
		{
			if (!cardObj)
				return;
			
			if (cemeteryCardList.indexOf(cardObj) == -1)
			{
				cemeteryCardList.push(cardObj);
				cardObj.updateRender(BaseCardObj.SKIN_HEAD_DEAD_TYPE);
				updateDisplay();
			}
			
		}
		
		public function removeCardToCemeteryArea(cardObj:BaseCardObj):void
		{
			if (!cardObj)
				return;
			
			var idx:int = cemeteryCardList.indexOf(cardObj);
			if (idx < 0)
				return;
		
			cemeteryCardList.splice(idx, 1);
			if (idx >= cemeteryCardList.length)	// 队列尾发生改变，更新显示
				updateDisplay();
		}
		
		private function updateDisplay():void
		{
			// 清理掉上次显示的Item，更新显示队列尾卡牌
			if (_lastShowItem)
			{
				if (_lastShowItem.parent)
					_lastShowItem.parent.removeChild(_lastShowItem);
				_lastShowItem = null;
			}
			
			var cardObj:BaseCardObj = cemeteryCardList[cemeteryCardList.length - 1];
			if (cardObj && cardObj.render)
			{
				cemeteryItem.addChild(cardObj.render);
				_lastShowItem = cardObj.render;
			}
			
		}
	}
}