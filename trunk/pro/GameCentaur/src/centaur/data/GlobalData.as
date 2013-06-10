package centaur.data
{
	import centaur.data.act.HeroData;
	import centaur.data.act.InsMapData;
	import centaur.data.card.CardData;
	import centaur.data.combat.CombatResultData;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.mainui.MainPanel;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.combat.CombatScene;
	
	public final class GlobalData
	{
		public static var asite:String = "";		// 资源路径
//		public static var starling:Starling;		// starling主对象
//		
//		public static var GAME_WIDTH:int = 960;
//		public static var GAME_HEIGHT:int = 640;
//		
		public static var mainPanel:MainPanel;
		
		public static function onGameResize(stageWidth:int, stageHeight:int):void
		{
			
			
		}
		
		public static function forTestCombat():void
		{
			var actDataA:HeroData = new HeroData();	// 角色卡组
			var cardData:CardData;
			actDataA.cardList = [];
			actDataA.maxHP = 6000;
			for (var i:int = 6; i <= 10; i++)
			{
				cardData = new CardData();
				cardData.templateID = i;
				cardData.update();
				actDataA.cardList.push(cardData);
			}
			
			var actA:BaseActObj = new BaseActObj(actDataA);
			
			var actDataB:InsMapData = new InsMapData();
			actDataB.cardList = [];
			actDataB.maxHP = 6000;
			for (var j:int = 1; j <= 5; j++)
			{
				cardData = new CardData();
				cardData.templateID = j;
				cardData.update();
				actDataB.cardList.push(cardData);
			}
			var actB:BaseActObj = new BaseActObj(actDataB);
			
			var logicData:CombatResultData = new CombatScene(actA, actB).start();
			
			////---- 处理战斗显示部分
			CombatPanel.instance.startPlay(logicData);
			GlobalAPI.layerManager.getPopLayer().addChild(CombatPanel.instance);
		}
	}
}