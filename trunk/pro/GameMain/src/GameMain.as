package
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.act.HeroData;
	import centaur.data.act.InsMapData;
	import centaur.data.card.CardData;
	import centaur.display.GameBase;
	import centaur.display.ui.login.LoginPanel;
	import centaur.loader.LoaderManager;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.combat.CombatScene;
	import centaur.manager.PathManager;
	import centaur.manager.TickManager;
	import centaur.movies.FanmMovieClip;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	
	import net.hires.debug.Stats;
	
	public class GameMain extends GameBase
	{
		public function GameMain()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			setup();
		}
		
		override protected function init():void
		{
			setupGlobals();
			
			// 初始化配置表
			InitConfig.initConfig();
			
			super.init();
		}
		
		protected function setupGlobals():void
		{
			GlobalData.asite = "D:/Tools/pro/assets/";	// 配置资源总路径
			GlobalAPI.pathManager = new PathManager;
			GlobalAPI.tickManager = new TickManager(stage);
			GlobalAPI.loaderManager = new LoaderManager;
		}
		
		protected function setup():void
		{
			////----wangq
			var loginPanel:LoginPanel = new LoginPanel();
			//this.addChild(loginPanel);
			
			////----wangq movie test
/*			var famMovie:FanmMovieClip = new FanmMovieClip(null);
			famMovie.setPath("fortest");
			famMovie.setLoop(3);
			famMovie.play();
			famMovie.x = famMovie.y = 150;
			addChild(famMovie);*/
			
			autoSize();
			
			// 初始化事件
			initEvents();
			
			// 调试帧频显示
			//addChild(new Stats());
			
			////----wangq
			forTest();
		}
		
		/**
		 *   根据不同分辨率调整游戏显示和资源缩放系数
		 */ 
		protected function autoSize():void
		{
			var factorX:Number = stage.stageWidth / GlobalData.GAME_WIDTH;
			var factorY:Number = stage.stageHeight / GlobalData.GAME_HEIGHT;
			if (factorX > factorY)
			{
				this.scaleX = this.scaleY = factorY;
				this.x = (stage.stageWidth - GlobalData.GAME_WIDTH * factorY) * 0.5;
			}
			else
			{
				this.scaleX = this.scaleY = factorX;
				this.y = (stage.stageHeight - GlobalData.GAME_HEIGHT * factorX) * 0.5;
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
		private function forTest():void
		{
			var actDataA:HeroData = new HeroData();	// 角色卡组
			var cardData:CardData;
			actDataA.cardList = [];
			actDataA.maxHP = 2000;
			for (var i:int = 0; i < 3; i++)
			{
				cardData = new CardData();
				cardData.templateID = 1;
				cardData.update();
				actDataA.cardList.push(cardData);
			}
			
			var actA:BaseActObj = new BaseActObj(actDataA);
			
			var actDataB:InsMapData = new InsMapData();
			actDataB.cardList = [];
			actDataB.maxHP = 2000;
			for (var j:int = 0; j < 3; j++)
			{
				cardData = new CardData();
				cardData.templateID = 2;
				cardData.update();
				actDataB.cardList.push(cardData);
			}
			var actB:BaseActObj = new BaseActObj(actDataB);
			
			var logicData:Object = new CombatScene(actA, actB).start();
		}
	}
}