package centaur.display.ui.combat
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.Sprite;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;

	/**
	 *   等待区面板
	 *   @author wangq 2013.04.12
	 */ 
	public final class WaitItemPanel extends GBuilderBase
	{
		public var waitItem1:GBase;			// 等待区的5个格子
		public var waitItem2:GBase;
		public var waitItem3:GBase;
		public var waitItem4:GBase;
		public var waitItem5:GBase;
		public var waitItemList:Array;		// 保存显示对象
		public var waitCardList:Array;		// 保存卡牌数据
		
		public function WaitItemPanel(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
			setup();
		}
		
		protected function setup():void
		{
			waitCardList = [];
			waitItemList = [waitItem1, waitItem2, waitItem3, waitItem4, waitItem5];
		}
			
		public function addCardToWaitArea(cardObj:BaseCardObj):void
		{
			waitCardList.push(cardObj);
			var idx:int = waitCardList.length - 1;
			
			// 更新卡牌的显示内容和位置
			cardObj.updateRender(BaseCardObj.SKIN_HEAD_TYPE);
			var parentContent:Sprite = waitItemList[idx] as Sprite;
			if (cardObj.render && parentContent)
				parentContent.addChild(cardObj.render);
		}
		
		public function removeCardFromWaitArea(cardObj:BaseCardObj):void
		{
			var idx:int = waitCardList.indexOf(cardObj);
			if (idx > -1)
			{
				waitCardList.splice(idx, 1);
				if (cardObj.render && cardObj.render.parent)
					cardObj.render.parent.removeChild(cardObj.render);
			}
		}
		
		public function onRoundEnd():void
		{
			updateWaitList(true);
		}
		
		private function updateWaitList(updateRoundCount:Boolean = false):void
		{
			var len:int = waitCardList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var cardObj:BaseCardObj = waitCardList[i];
				if (!cardObj)
					continue;
				
				var parentContent:Sprite = waitItemList[i] as Sprite;
				if (cardObj.render && parentContent && parentContent != cardObj.render.parent)
					parentContent.addChild(cardObj.render);
			}
		}
	}
}