package centaur.data
{
	import centaur.data.act.HeroData;
	import centaur.data.act.InsMapData;
	import centaur.data.card.CardData;
	import centaur.data.combat.CombatResultData;
	import centaur.data.player.PlayerInfo;
	import centaur.display.ui.card.CardDetailPanel;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.mainui.MainPanel;
	import centaur.display.ui.map.MapPanel;
	import centaur.display.ui.role.ConfigCardPanel;
	import centaur.display.ui.role.RoleCardPanel;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.combat.CombatScene;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public final class GlobalData
	{
		public static var asite:String = "";		// 资源路径
		public static var macAddress:String = "";	// 物理地址
//		public static var starling:Starling;		// starling主对象
//		
//		public static var GAME_WIDTH:int = 960;
//		public static var GAME_HEIGHT:int = 640;
//		
		public static var mainPlayerInfo:PlayerInfo;
		public static var mainActData:HeroData;
		public static var mainActObj:BaseActObj;
		
		public static var gameMain:Sprite;
		public static var mainPanel:MainPanel;
		public static var detailCardPanel:CardDetailPanel;
		public static var mapPanel:MapPanel;
		public static var roleCardPanel:RoleCardPanel;		// 角色卡组信息面板
		public static var configCardPanel:ConfigCardPanel; 	// 角色卡牌配置面板
		
		public static function onGameResize(stageWidth:int, stageHeight:int):void
		{
			
			
		}
		
		public static function popupCardDetailPanel(cardData:BaseCardObj):void
		{
			if (!detailCardPanel)
				detailCardPanel = new CardDetailPanel();
			
			if (!detailCardPanel.parent)
				GlobalAPI.layerManager.setModuleContent(detailCardPanel);
			
			detailCardPanel.cardData = cardData;
			
			GlobalEventDispatcher.dispatch(new Event(GlobalEventDispatcher.DETAIL_CARD_SHOW));
		}
		
		public static function hideCardDetailPanel():void
		{
			if (detailCardPanel && detailCardPanel.parent)
				detailCardPanel.parent.removeChild(detailCardPanel);
			
			GlobalAPI.layerManager.returnLastModule();
			GlobalEventDispatcher.dispatch(new Event(GlobalEventDispatcher.DETAIL_CARD_HIDE));
		}
		
		public static function forTestCombat(actDataB:InsMapData):void
		{
			var actDataA:HeroData = new HeroData();	// 角色卡组
			var cardData:CardData;
			actDataA.cardList = [];
			actDataA.maxHP = 6000;
			for (var i:int = 16; i <= 20; i++)
			{
				cardData = new CardData();
				cardData.templateID = i;
				cardData.update();
				actDataA.cardList.push(cardData);
			}
			
			var actA:BaseActObj = new BaseActObj(actDataA);
			
//			var actDataB:InsMapData = new InsMapData();
//			actDataB.cardList = [];
//			actDataB.maxHP = 6000;
//			for (var j:int = 1; j <= 5; j++)
//			{
//				cardData = new CardData();
//				cardData.templateID = j;
//				cardData.update();
//				actDataB.cardList.push(cardData);
//			}
			var actB:BaseActObj = new BaseActObj(actDataB);
			
			var logicData:CombatResultData = new CombatScene(actA, actB).start();
			
			////---- 处理战斗显示部分
			CombatPanel.instance.startPlay(logicData);
			GlobalAPI.layerManager.setModuleContent(CombatPanel.instance);
		}
	}
}