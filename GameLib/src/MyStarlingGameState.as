package
{
	import centaur.assets.AssetManager;
	import centaur.scene.consts.EntityType;
	import centaur.scene.data.entity.EntityData;
	import centaur.scene.entity.EntityManager;
	import centaur.scene.entity.elements.MainPlayer;
	import centaur.scene.entity.elements.MovableBall;
	import centaur.scene.view.GameView;
	import centaur.utils.DebugTrace;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.view.CitrusView;
	import com.citrusengine.view.starlingview.StarlingView;
	
	import flash.events.AccelerometerEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public final class MyStarlingGameState extends StarlingState
	{
		private var _hero:MainPlayer;
		private var _engine:CitrusEngine;
		
//		protected var _currentBall:MovableBall;
		protected var _lastMouseDownPoint:Point = new Point();
		
		protected var _accelerometer:Accelerometer;
		
		public function MyStarlingGameState()
		{
			_engine = CitrusEngine.getInstance();
			super();
		}
		
//		override protected function createView():CitrusView
//		{
//			return new GameView(this);
//		}
		
		override public function initialize():void
		{
			super.initialize();
			
//			var viewRoot:Sprite = (view as StarlingView).viewRoot;
//			if (viewRoot.numChildren == 0)
//				viewRoot.addChild(new Sprite());
			
			DebugTrace.debugTrace("setup OK");
			
			var backSprite:CitrusSprite = new CitrusSprite("background", {x : 0, y : 0, group : 0});
			var backImage:Image = new Image(AssetManager.instance.getTexture("img/map/background"));
			backSprite.view = backImage;
			add(backSprite);
			
			DebugTrace.debugTrace("init backImage!!!");
			
//			var box2D:Box2D = new Box2D("Box2D");
//			box2D.world.SetGravity(new V2(0, 9.8));
//			this.add(box2D);
//			box2D.visible = true;
			
//			var napeObj:Nape = new Nape("nape");
//			napeObj.gravity = new Vec2(0, 9.8);
//			add(napeObj);
//			
//			DebugTrace.debugTrace("init Nape");
//			
//			var heroTexture:Texture = Texture.fromBitmapData(AssetManager.instance.heroBitmap);
//			var heroXML:XML = AssetManager.instance.heroXMLData;
//			
//			var textureAlas:TextureAtlas = new TextureAtlas(heroTexture, heroXML);
//			_hero = new MainPlayer("Hero", {x : 100, y : 100, width : 40, height : 130, group: 1});
//			_hero.view = new AnimationSequence(textureAlas, ["walk", "duck", "idle", "jump", "hurt"], "idle");
//			add(_hero);
//			_hero.jumpHeight = 25;
//			
//			DebugTrace.debugTrace("init Hero");
//			
//			view.setupCamera(_hero, new MathVector(300, 300), null, null); 
//			
//			
//			var platform:Platform = new Platform("platform1", {x : 50, y : 300, width : 100, height : 20/*, oneWay : "true"*/});
//			var platformView:Image = new Image(AssetManager.instance.getTexture("stone"));
//			platformView.scaleX = 100 / platformView.width;
//			platformView.scaleY = 20 / platformView.height;
//			platform.view = platformView;
//			add(platform);
			
//			var entityData:EntityData = new EntityData;
//			entityData.entityType = EntityType.PLATFORM;
//			entityData.x = 50;
//			entityData.y = 300;
//			entityData.width = 100;
//			entityData.height = 20;
//			entityData.group = 1;
//			var platformObj:CitrusObject = EntityManager.instance.getAvailableEntity(entityData);
//			if (platformObj)
//				add(platformObj);
			
			
			
//			initEntites();
			
			addEvents();
		}
		
		protected function initEntites():void
		{
			for (var height:int = 500; height > -2000; height -= 20)
			{
				var entityData:EntityData = new EntityData;
//				entityData.type = "";
				entityData.entityType = EntityType.PLATFORM;
				entityData.x = 100 + Math.random() * 500;
				entityData.y = height;
				entityData.width = 100;
				entityData.height = 20;
				entityData.group = 1;
				entityData.oneWay = true;
				
				var platformObj:CitrusObject = EntityManager.instance.getAvailableEntity(entityData);
				if (platformObj)
					add(platformObj);
			}
		}
		
		protected function addEvents():void
		{
			DebugTrace.debugTrace("addEvents !!!");
			
			if (Accelerometer.isSupported)
			{
				DebugTrace.debugTrace("init Accelerometer");
				
				_accelerometer = new Accelerometer();
				_accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAcceleUpdate);
				_accelerometer.setRequestedUpdateInterval(1000);
			}
			
			this.stage.addEventListener(TouchEvent.TOUCH, onStageTouch);
		}
		
		protected function removeEvents():void
		{
		}
		
		private function onAcceleUpdate(e:AccelerometerEvent):void
		{
			var xAxis:Number = e.accelerationX;
			var yAxis:Number = e.accelerationY;
			var zAxis:Number = e.accelerationZ;
			
			DebugTrace.debugTrace("xAxis = " + xAxis + "  yAxis = " + yAxis + "  zAxis = " + zAxis);
		}
		
		private var _isInTouch:Boolean = false;
		private var _deltaX:Number = 0.0;
		private var _deltaY:Number = 0.0;
		protected function onStageTouch(e:TouchEvent):void
		{
			var touches:Vector.<Touch> = e.touches;
			var length:int = touches.length;
			if (length == 1)
			{
				var touch:Touch = touches[0];
				var phase:String = touch.phase;
				if (phase == TouchPhase.MOVED)
				{
					_isInTouch = true;
					var delta:Point = touch.getMovement(parent);
					_deltaX += delta.x;
					_deltaY += delta.y;
				}
				else if (phase == TouchPhase.ENDED)
				{
					_isInTouch = false;
					if (Math.abs(_deltaX) > 5 || Math.abs(_deltaY) > 5)
					{
						_hero.jump();
					}
					_deltaX = _deltaY = 0;
				}
				if (_isInTouch)
				{
					// move
				}
			}
//			else if (length == 1)
//			{
				_isInTouch = true;
//			}
			
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			trace("onMouseDown");
			(view as StarlingView).viewRoot.y -= 10;
			
			
//			return;////----wangq
//			_lastMouseDownPoint.x = e.stageX;
//			_lastMouseDownPoint.y = e.stageY;
//			if (!_currentBall)
//			{
//				_currentBall = new MovableBall("ball" + Math.random() * int.MAX_VALUE, {x : _lastMouseDownPoint.x, y : _lastMouseDownPoint.y, radius : 20, group : 1});
//				_currentBall.view = new Image(Texture.fromBitmapData(AssetManager.instance.ball1));
//				add(_currentBall);
//			}
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			trace("onMouseUp");
//			if (!_currentBall)
//				return;
//			
//			var distancePoint:Point = _lastMouseDownPoint.subtract(new Point(e.stageX, e.stageY));
//			var length:Number = distancePoint.length;
//			if (length >= 200)
//				length = 200;
//			distancePoint.normalize(length);
////			distancePoint = new Point(Math.random() * 100, Math.random() * 100);
//			
//			_currentBall.setLinearVelocity(distancePoint);
//			_currentBall = null;
		}
	}
}