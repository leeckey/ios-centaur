package centaur.display.ui.role
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.player.PlayerInfo;
	import centaur.display.control.GBitmapNumberText;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.render.CardMediumRender;
	import centaur.utils.NumberCache;
	import centaur.utils.NumberType;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;

	/**
	 *   角色卡组配置面板
	 */ 
	public final class RoleCardPanel extends GBuilderBase
	{
		public var heroLvText:GBitmapNumberText;
		public var heroHPText:GBitmapNumberText;
		public var costText:GBitmapNumberText;
		public var cardTeamText:GBitmapNumberText;
		public var totalAttackText:GBitmapNumberText;
		public var totalBodyText:GBitmapNumberText;
		
		public var runeConfigBtn:GButton;
		public var cardConfigBtn:GButton;
		public var returnBtn:GButton;
		
		public var cardBg1:GBase;
		public var cardBg2:GBase;
		public var cardBg3:GBase;
		public var cardBg4:GBase;
		public var cardBg5:GBase;
		public var cardBg6:GBase;
		public var cardBg7:GBase;
		public var cardBg8:GBase;
		public var cardBg9:GBase;
		public var cardBg10:GBase;
		
		private var cardBgList:Array;
		private var cardRenderList:Array;
		
		public function RoleCardPanel()
		{
			super(RoleCardInfoPanelAsset);
			setup();
		}
		
		private function updateInfo():void
		{
			if (!GlobalData.mainPlayerInfo)
				return;
			
			heroLvText.setNumber(GlobalData.mainPlayerInfo.lv, NumberType.SMALL_WHITE_NUMBER);
			heroHPText.setNumber(GlobalData.mainPlayerInfo.heroHP, NumberType.SMALL_WHITE_NUMBER);
			costText.setNumber(GlobalData.mainPlayerInfo.cost, NumberType.SMALL_WHITE_NUMBER);
			cardTeamText.setNumber(GlobalData.mainPlayerInfo.cardTeam, NumberType.SMALL_WHITE_NUMBER);
			totalAttackText.setNumber(GlobalData.mainPlayerInfo.totalAttack, NumberType.SMALL_WHITE_NUMBER);
			totalBodyText.setNumber(GlobalData.mainPlayerInfo.totalBody, NumberType.SMALL_WHITE_NUMBER);
		}
		
		private function setup():void
		{
			cardRenderList = [];
			cardBgList = [cardBg1, cardBg2, cardBg3, cardBg4, cardBg5, cardBg6, cardBg7, cardBg8, cardBg9, cardBg10];
			addEvents();
			
			updateInfo();
			updateCombatCardDisplay();
		}
		
		private function updateCombatCardDisplay():void
		{
			var cardObjList:Array = GlobalData.mainActObj.cardObjList;
			if (!cardObjList)
				return;
			var combatIdxList:Array = GlobalData.mainActData.combatCardIdxList;
			if (!combatIdxList)
				return;
			
			var len:int = cardBgList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var container:GBase = cardBgList[i];
				var render:CardMediumRender = cardRenderList[i];
				var cardObj:BaseCardObj = cardObjList[combatIdxList[i]];
				if (render && cardObj && render.parent == container && render.cardObj == cardObj)
					continue;
				
				// 卡信息不存在，移除显示对象
				if (!cardObj)
				{
					if (render && render.parent)
						render.parent.removeChild(render);
					cardBgList[i] = null;
				}
				else
				{
					if (!render || render.cardObj != cardObj)
						render = new CardMediumRender(cardObj);
					cardBgList[i] = render;
					if (render.parent != container)
						container.addChild(render);
				}
			}
		}
		
		private function addEvents():void
		{
			returnBtn.addEventListener(MouseEvent.CLICK, onReturnBtnClick);
			cardConfigBtn.addEventListener(MouseEvent.CLICK, onCardConfigBtnClick);
		}
		
		private function removeEvents():void
		{
			returnBtn.removeEventListener(MouseEvent.CLICK, onReturnBtnClick);
			cardConfigBtn.removeEventListener(MouseEvent.CLICK, onCardConfigBtnClick);
		}
		
		private function onReturnBtnClick(e:MouseEvent):void
		{
			GlobalAPI.layerManager.returnLastModule();
		}
		
		private function onCardConfigBtnClick(e:MouseEvent):void
		{
			if (!GlobalData.configCardPanel)
				GlobalData.configCardPanel = new ConfigCardPanel();
			GlobalAPI.layerManager.setModuleContent(GlobalData.configCardPanel);
		}
	}
}