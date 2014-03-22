package
{
	import centaur.data.GameConstant;
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.act.HeroData;
	import centaur.data.act.InsMapData;
	import centaur.data.card.CardData;
	import centaur.data.combat.CombatResultData;
	import centaur.data.player.PlayerInfo;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandlerManager;
	import centaur.display.ui.login.LoginPanel;
	import centaur.display.ui.mainui.MainPanel;
	import centaur.effects.EffectManager;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.combat.CombatScene;
	import centaur.manager.DelayCallTimerManager;
	import centaur.manager.EmbedAssetManager;
	import centaur.manager.LayerManager;
	import centaur.manager.PathManager;
	import centaur.manager.TickManager;
	import centaur.utils.GSaveManager;
	import centaur.utils.shareobject.PlayerInfoShareManager;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ghostcat.ui.controls.GText;
	
	import net.HttpNetManager;
	import net.hires.debug.Stats;
	
	import network.NetWorkInfoHelper;
	
	public class GameMain extends Sprite
	{
//		[Embed(source="font/embedfont3.otf", fontName="simhei", embedAsCFF="false", mimeType="application/x-font")]
//		private var Font1 : Class;
		
//		[Embed(systemFont="Arial", fontName="FontName", fontWeight="bold", unicodeRange="U+8f93,U+5165,U+6587,U+5b57,", mimeType="application/x-font")]
//		var Font1 : Class;
		
		public function GameMain()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			
			init();
			setup();
		}
		
		protected function init():void
		{
			Font.registerFont(FontLibrary.Embed_HEI);
			GText.defaultEmbedFont = FontLibrary.fontName1;
			
//			var a:Array = Font.enumerateFonts(true);
//			
//			var format:TextFormat = new TextFormat("font1", 30);
//			var  text:TextField = new TextField();
//			text.autoSize = TextFieldAutoSize.LEFT;
//			text.antiAliasType = AntiAliasType.ADVANCED;
//			
//			text.border = true;
//			text.embedFonts = true;
//			text.text = "123中文字体示范abc伤害长枪兵";
//			text.setTextFormat(format);
//			this.addChild(text);
//			
//			return;////----wangq
			setupGlobals();
			
			// 初始化配置表
			InitConfig.initConfig();
			
			////----wangq
			GlobalData.macAddress = NetWorkInfoHelper.getHardwareAddress();
			
			var text:TextField = new TextField();
			text.mouseEnabled = false;
			text.text = "Mac地址  == " + GlobalData.macAddress;
			text.width = 200;
			text.x = 200;
			addChild(text);
		}
		
		protected function setupGlobals():void
		{
			GlobalData.asite = "";	// 配置资源总路径
			GlobalData.gameMain = this;
			GlobalAPI.pathManager = new PathManager;
			GlobalAPI.tickManager = new TickManager(stage);
			GlobalAPI.loaderManager = new AirLoadManager;
			GlobalAPI.actionHandlerManager = new ActionHandlerManager;
			GlobalAPI.effectManager = new EffectManager;
			GlobalAPI.layerManager = new LayerManager(this);
			GlobalAPI.timerManager = new DelayCallTimerManager();
			GlobalAPI.httpManager = new HttpNetManager();
			
			EmbedAssetManager.setup();
		}
		
		protected function setup():void
		{
			// 初始化事件
			initEvents();
			
			autoSize();
			
			// 调试帧频显示
			var stats:Stats = new Stats();
			stats.y = 100;
			addChild(stats);
			
//			if (!GlobalData.mainPanel)
//				GlobalData.mainPanel = new MainPanel();
//			GlobalAPI.layerManager.setModuleContent(GlobalData.mainPanel);
			var loginPanel:LoginPanel = new LoginPanel();
			this.addChild(loginPanel);
			
			////----wangq
			GSaveManager.instance.clear();
			initMainInfo();
//			var test:PlayerInfo = PlayerInfoShareManager.getSharePlayerInfo();
////			GSaveManager.instance.clear();
//			
//			////---- wangq
//			GlobalData.mainPlayerInfo = new PlayerInfo();
//			GlobalData.mainPlayerInfo.lv =1;
//			GlobalData.mainPlayerInfo.heroHP = 4567;
//			GlobalData.mainPlayerInfo.cost = 28;
//			GlobalData.mainPlayerInfo.cardTeam = 1;
//			GlobalData.mainPlayerInfo.totalAttack = 1234;
//			GlobalData.mainPlayerInfo.totalBody = 58;
//			GlobalData.mainPlayerInfo.maxBody = 70;
//			GlobalData.mainPlayerInfo.maxCombatCard = 6;
//			GlobalData.mainPlayerInfo.mapEnableCount = 2;
//			GlobalData.mainPlayerInfo.insFinishList = [1,2, 4,5,6, 7, 10,11,12  ];	//  模拟记录角色已完成的关卡ID
//			
////			PlayerInfoShareManager.setSharePlayerInfo(GlobalData.mainPlayerInfo);
//			
//			GlobalData.mainActData = new HeroData();
//			var cardData:CardData;
//			GlobalData.mainActData.cardList = [];
//			GlobalData.mainActData.maxHP = 6000;
//			for (var i:int = 6; i <= 10; i++)
//			{
//				cardData = new CardData();
//				cardData.templateID = i;
//				cardData.update();
//				GlobalData.mainActData.cardList.push(cardData);
//			}
//			GlobalData.mainActData.combatCardIdxList = [0, 1, 2, 3];
//			GlobalData.mainActObj = new BaseActObj(GlobalData.mainActData);
			
		}
		
		private function initMainInfo():void
		{
			GlobalData.mainPlayerInfo = PlayerInfoShareManager.getSharePlayerInfo();
			if (!GlobalData.mainPlayerInfo)
			{
				GlobalData.mainPlayerInfo = new PlayerInfo();
				GlobalData.mainPlayerInfo.lv =1;
				GlobalData.mainPlayerInfo.heroHP = 5000;
				GlobalData.mainPlayerInfo.cost = 5;
				GlobalData.mainPlayerInfo.cardTeam = 1;
				GlobalData.mainPlayerInfo.totalAttack = 123;
				GlobalData.mainPlayerInfo.totalBody = 50;
				GlobalData.mainPlayerInfo.maxBody = 70;
				GlobalData.mainPlayerInfo.maxCombatCard = 4;
				GlobalData.mainPlayerInfo.mapEnableCount = 1;
				GlobalData.mainPlayerInfo.insFinishList = [1,2, 4,5,6, 7, 10,11,12 ,13, 16 ];	//  模拟记录角色已完成的关卡ID
			
				PlayerInfoShareManager.setSharePlayerInfo(GlobalData.mainPlayerInfo);
			}
			
			GlobalData.mainActData = PlayerInfoShareManager.getShareHeroData();
			if (!GlobalData.mainActData)
			{
				GlobalData.mainActData = new HeroData();
				var cardData:CardData;
				GlobalData.mainActData.cardList = [];
				GlobalData.mainActData.maxHP = 5000;
				for (var i:int = 20; i <= 29; i++)
				{
					cardData = new CardData();
					cardData.templateID = i;
					cardData.lv = 10;
					cardData.update();
					GlobalData.mainActData.cardList.push(cardData);
				}
				GlobalData.mainActData.combatCardIdxList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
				
				PlayerInfoShareManager.setShareHeroData(GlobalData.mainActData);
			}
			
			GlobalData.mainPlayerInfo.totalBody = 50;
			GlobalData.mainActObj = new BaseActObj(GlobalData.mainActData);
			
		}
		
		/**
		 *   根据不同分辨率调整游戏显示和资源缩放系数
		 */ 
		protected function autoSize():void
		{
			var factorX:Number = stage.stageWidth / GameConstant.STAGE_WIDTH;
			var factorY:Number = stage.stageHeight / GameConstant.STAGE_HEIGHT;
			if (factorX > factorY)
			{
				this.scaleX = this.scaleY = factorY;
				this.x = (stage.stageWidth - GameConstant.STAGE_WIDTH * factorY) * 0.5;
				this.y = 0;
			}
			else
			{
				this.scaleX = this.scaleY = factorX;
				this.x = 0;
				this.y = (stage.stageHeight - GameConstant.STAGE_HEIGHT * factorX) * 0.5;
			}
			
		}
		
		protected function initEvents():void
		{
			// 阻止休眠
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			// 使屏幕为横版模式
			if (Stage.supportsOrientationChange)
			{
				stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onStageOrientationChanging);
				stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onStageOrientationChange);
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		private function onEnterFrame(e:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (stage.orientation == StageOrientation.ROTATED_LEFT || stage.orientation == StageOrientation.UPSIDE_DOWN)
				stage.setOrientation(StageOrientation.ROTATED_LEFT);
			else if (stage.orientation == StageOrientation.ROTATED_RIGHT || stage.orientation == StageOrientation.DEFAULT)
				stage.setOrientation(StageOrientation.ROTATED_RIGHT);
		}
		
		private function onStageOrientationChange(e:StageOrientationEvent):void
		{
			switch (e.afterOrientation)
			{
				case StageOrientation.DEFAULT:
				{
					break;	
				}
				case StageOrientation.ROTATED_LEFT:
				{
					stage.setOrientation(StageOrientation.ROTATED_LEFT);
					break;	
				}
				case StageOrientation.ROTATED_RIGHT:
				{
					stage.setOrientation(StageOrientation.ROTATED_RIGHT);
					break;	
				}
				case StageOrientation.UPSIDE_DOWN:
				{
					break;	
				}	
			}
		}
		
		private function onStageOrientationChanging(e:StageOrientationEvent):void
		{
			// 横版显示，避免竖着旋转
			if (e.afterOrientation == StageOrientation.DEFAULT ||
				e.afterOrientation == StageOrientation.UPSIDE_DOWN)
				e.preventDefault();
		}
		
		private function onStageResize(e:Event):void
		{
			autoSize();
			GlobalData.onGameResize(stage.stageWidth, stage.stageHeight);
		}
		
		////----wangqing
		public function forTestCombat():void
		{
			var actDataA:HeroData = new HeroData();	// 角色卡组
			var cardData:CardData;
			actDataA.cardList = [];
			actDataA.maxHP = 6000;
			for (var i:int = 26; i <= 30; i++)
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
			for (var j:int = 21; j <= 25; j++)
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
		
//		private function forLoadSWFTest():void
//		{
//			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
//			var loader:Loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFComplete);
//			loader.load(new URLRequest("assets/effects/11.swf")/*, loaderContext*/);
//			loader.x = 480;
//			loader.y = 320;
//			GlobalAPI.layerManager.getTopLayer().addChild(loader);
//		}
//		private function onSWFComplete(e:Event):void
//		{
//			////----wangq
//			var famMovie:IMovieClip = MovieClipFactory.getAvailableMovie();
//			famMovie.setPath("assets/effects/jgjf01.fam");
//			famMovie.play();
//			famMovie.setLoop(3);
//			famMovie.x = 200;
//			famMovie.y = 200;
//			famMovie.addEventListener(Event.COMPLETE, onFamComplete);
//			GlobalAPI.layerManager.getTipLayer().addChild(famMovie as DisplayObject);
//			
//			forTest();
//		}
//		
//		private function onFamComplete(e:Event):void
//		{
//			var fam:FanmMovieClip = e.currentTarget as FanmMovieClip;
//			MovieClipFactory.recycleMovie(fam);
//		}
		
	}
}