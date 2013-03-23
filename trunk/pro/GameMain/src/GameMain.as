package
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.act.ActData;
	import centaur.data.act.HeroData;
	import centaur.data.act.InsMapData;
	import centaur.data.card.CardData;
	import centaur.data.card.CardTemplateDataList;
	import centaur.display.GameBase;
	import centaur.display.ui.login.LoginPanel;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.combat.CombatScene;
	import centaur.manager.PathManager;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
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
		}
		
		protected function setup():void
		{
			////----wangq
			var loginPanel:LoginPanel = new LoginPanel();
			this.addChild(loginPanel);
			
			autoSize();
			
			// 初始化事件
			initEvents();
			
			// 调试帧频显示
			addChild(new Stats());
			
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
			var cardData:CardData = new CardData();
			cardData.templateID = 1;
			cardData.update();
			actDataA.cardList = [cardData];
			actDataA.maxHP = 236;
			var actA:BaseActObj = new BaseActObj(actDataA);
			
			var actDataB:InsMapData = new InsMapData();
			var cardDataB:CardData = new CardData();
			cardDataB.templateID = 2;
			cardDataB.update();
			actDataB.cardList = [cardDataB];
			actDataB.maxHP = 186;
			var actB:BaseActObj = new BaseActObj(actDataB);
			
			var logicData:Object = new CombatScene(actA, actB).start();
		}
	}
}