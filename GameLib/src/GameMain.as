package
{
	import baozha.*;
	
	import centaur.assets.AssetManager;
	import centaur.utils.DebugTrace;
	
	import com.citrusengine.core.CitrusEngine;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class GameMain extends CitrusEngine
	{
		protected var _viewPort:Rectangle;
		
		public function GameMain()
		{
//			this.setUpStarling(true);
//			
//			this._starling.stage.addChild(new Sprite());
//			
//			
			super();
			
			
			
			// starling sprite
			updateViewPort();
			this.setUpStarling(true, 1, _viewPort);
//			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);////----wangq
			
			DebugTrace.setup(_starling.stage);
			state = new MyStarlingGameState();
			
			
			// flash sprite
//			state = new GameState();
			
			
			
		}
		
		protected function updateViewPort():void
		{
			_viewPort =  new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			
			if (_viewPort.width == 768) // iPad 1+2
				_viewPort.setTo(64, 32, 640, 960);
			else if (_viewPort.width == 1536) // iPad 3
				_viewPort.setTo(128, 64, 1280, 1920);
		}
		
		override public function setUpStarling(debugMode:Boolean=false, antiAliasing:uint=1, viewPort:Rectangle = null):void
		{
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = false; // not necessary on iOS. Saves a lot of memory!
			
			super.setUpStarling(debugMode, antiAliasing, viewPort);
		}
		
		public function startStarling():void
		{
			
//			this.setUpStarling(true);
//			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
		}
		
		private function onContext3DCreated(e:Event):void
		{
			var img1:Image = new Image(AssetManager.instance.getTexture("img/map/background"));
			_starling.stage.addChild(img1);
			
			return;
			
//			graphics.beginFill(0xff0000);
//			graphics.drawRect(0, 0, 1000, 400);
//			graphics.endFill();
			
			var img:Image = new Image(Texture.fromBitmapData(AssetManager.instance.background1));
			_starling.stage.addChild(img);
			return;
//			// 动画测试
//			var textureVector:Vector.<Texture> = new Vector.<Texture>();
//			textureVector.push(Texture.fromBitmapData(new boom00001_png));
//			textureVector.push(Texture.fromBitmapData(new boom00002_png));
//			textureVector.push(Texture.fromBitmapData(new boom00003_png));
//			textureVector.push(Texture.fromBitmapData(new boom00004_png));
//			textureVector.push(Texture.fromBitmapData(new boom00005_png));
//			textureVector.push(Texture.fromBitmapData(new boom00006_png));
//			textureVector.push(Texture.fromBitmapData(new boom00007_png));
//			
//			var movie:DynamicMovieClip = new DynamicMovieClip(textureVector, 6);
//			movie.x = 50;
//			movie.y = 100;
//			movie.loop = true;
//			movie.play();
//			movie.addEventListener(TouchEvent.TOUCH, onTouch);
//			_starling.stage.addChild(movie);
//			
//			
//			_starling.juggler.add(movie);
//			
//			var box2D:Box2D = new Box2D("Box2D");
			
		}
		
		private function onTouch(e:TouchEvent):void
		{
			
		}
			
			
	}
}