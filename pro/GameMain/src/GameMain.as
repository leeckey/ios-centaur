package
{
	import centaur.data.GameConstant;
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.act.HeroData;
	import centaur.data.act.InsMapData;
	import centaur.data.card.CardData;
	import centaur.data.combat.CombatResultData;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandlerManager;
	import centaur.effects.EffectManager;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.combat.CombatScene;
	import centaur.manager.DelayCallTimerManager;
	import centaur.manager.EmbedAssetManager;
	import centaur.manager.LayerManager;
	import centaur.manager.PathManager;
	import centaur.manager.TickManager;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	
	import net.hires.debug.Stats;
	
	public class GameMain extends Sprite
	{
		public function GameMain()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			init();
			setup();
		}
		
		protected function init():void
		{
			setupGlobals();
			
			// 初始化配置表
			InitConfig.initConfig();
		}
		
		protected function setupGlobals():void
		{
			GlobalData.asite = "";	// 配置资源总路径
			GlobalAPI.pathManager = new PathManager;
			GlobalAPI.tickManager = new TickManager(stage);
			GlobalAPI.loaderManager = new AirLoadManager;
			GlobalAPI.actionHandlerManager = new ActionHandlerManager;
			GlobalAPI.effectManager = new EffectManager;
			GlobalAPI.layerManager = new LayerManager(this);
			GlobalAPI.timerManager = new DelayCallTimerManager();
			
			EmbedAssetManager.setup();
		}
		
		protected function setup():void
		{
			// 初始化事件
			initEvents();
			
			autoSize();
			
			// 调试帧频显示
			addChild(new Stats());
			
			////----wangq
			forTest();
//			forLoadSWFTest();
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
			}
			else
			{
				this.scaleX = this.scaleY = factorX;
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
		private function forTest():void
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