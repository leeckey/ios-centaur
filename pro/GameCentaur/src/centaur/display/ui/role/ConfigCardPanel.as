package centaur.display.ui.role
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.card.CardData;
	import centaur.data.player.PlayerInfo;
	import centaur.display.control.ScaledScrollPanel;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.render.CardHeadDeadRender;
	import centaur.logic.render.CardHeadRender;
	import centaur.logic.render.CardMediumRender;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;

	public final class ConfigCardPanel extends GBuilderBase
	{
		public var cardHeadBg1:ConfigHeadCardItem;
		public var cardHeadBg2:ConfigHeadCardItem;
		public var cardHeadBg3:ConfigHeadCardItem;
		public var cardHeadBg4:ConfigHeadCardItem;
		public var cardHeadBg5:ConfigHeadCardItem;
		public var cardHeadBg6:ConfigHeadCardItem;
		public var cardHeadBg7:ConfigHeadCardItem;
		public var cardHeadBg8:ConfigHeadCardItem;
		public var cardHeadBg9:ConfigHeadCardItem;
		public var cardHeadBg10:ConfigHeadCardItem;
		
		public var cardScrollPanelBg:GBase;
		public var saveBtn:GButton;
		public var returnBtn:GButton;
		
		private var cardScrollPanel:ScaledScrollPanel;
		private var cardHeadContainerList:Array;
		
		private var cardItemList:Array;
		
		public function ConfigCardPanel()
		{
			super(ConfigCardPanelAsset);
			setup();
		}
		
		override public function destory():void
		{
			super.destory();
		}
		
		private function setup():void
		{
			cardHeadContainerList = [cardHeadBg1, cardHeadBg2, cardHeadBg3, cardHeadBg4, cardHeadBg5, 
				cardHeadBg6, cardHeadBg7, cardHeadBg8, cardHeadBg9, cardHeadBg10];
			
			cardScrollPanel = new ScaledScrollPanel();
			cardScrollPanelBg.addChild(cardScrollPanel);
			cardScrollPanel.wheelDirect = UIConst.HORIZONTAL;
			cardScrollPanel.wheelSpeed = 1;
			cardScrollPanel.scrollRect = new Rectangle(0, -100, 1200, 600);
			
			initCardData();
			initCombatCardData();
			addEvents();
		}
		
		/**
		 *   显示所有卡牌的滚动列表
		 */
		private function initCardData():void
		{
			var cardObjList:Array = GlobalData.mainActObj.cardObjList;
			if (!cardObjList)
				return;
			
			var itemWidth:Number;
			var itemHeight:Number;
			cardItemList = [];
			var len:int = cardObjList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var cardObj:BaseCardObj = cardObjList[i];
				var item:CardMediumRender = cardItemList[i];
				if (!item)
					item = cardItemList[i] = new CardMediumRender(cardObj);
				itemWidth = item.width;
				itemHeight = item.height;
			}
			
			cardScrollPanel.setupContent(cardItemList, itemWidth + 2, itemHeight);
		}
		
		/**
		 *   显示选为战斗的卡牌
		 */ 
		private function initCombatCardData():void
		{
			var cardObjList:Array = GlobalData.mainActObj.cardObjList;
			if (!cardObjList)
				return;
			var combatIdxList:Array = GlobalData.mainActData.combatCardIdxList;
			if (!combatIdxList)
				return;
			
			var maxCardCount:int = GlobalData.mainPlayerInfo.maxCombatCard;
			var headItemList:Array = [];
			var len:int = cardHeadContainerList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var container:ConfigHeadCardItem = cardHeadContainerList[i];
				container.setCardEnable(i < maxCardCount);
				var cardObj:BaseCardObj = cardObjList[combatIdxList[i]];
				if (!cardObj)
					continue;
				
				var headItem:CardHeadRender = new CardHeadRender(cardObj);
				headItemList.push(headItem);
				
				container.setHeadRender(headItem);
			}
		}
		
		private function addEvents():void
		{
			saveBtn.addEventListener(MouseEvent.CLICK, onSaveBtnClick);
			returnBtn.addEventListener(MouseEvent.CLICK, onReturnBtnClick);
		}
		
		private function removeEvents():void
		{
			saveBtn.removeEventListener(MouseEvent.CLICK, onSaveBtnClick);
			returnBtn.removeEventListener(MouseEvent.CLICK, onReturnBtnClick);
		}
		
		private function onSaveBtnClick(e:MouseEvent):void
		{
		}
		
		private function onReturnBtnClick(e:MouseEvent):void
		{
			GlobalAPI.layerManager.returnLastModule();
		}
	}
}