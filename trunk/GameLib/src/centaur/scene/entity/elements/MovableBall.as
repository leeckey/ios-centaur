package centaur.scene.entity.elements
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	
	import com.citrusengine.objects.NapePhysicsObject;
	
	import flash.geom.Point;

	public final class MovableBall extends NapePhysicsObject
	{
		public static const DEFAULT_BALL_SIZE:int = 1;
		
		public function MovableBall(name:String, params:Object = null)
		{
			super(name, params);
			
//			gravity = 0.0;
		}
		
		public function setLinearVelocity(velocity:Point):void
		{
//			if (_bodyDef.type == b2Body.b2_dynamicBody)
//			{
//				_body.SetAwake(true);
//				_body.SetLinearVelocity(new V2(velocity.x / _box2D.scale, velocity.y / _box2D.scale));
//			}
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
		}
		
//		override protected function defineFixture():void
//		{
//			super.defineFixture();
//			_fixtureDef.restitution = 1;
//			
//		}
		
//		override protected function createShape():void
//		{
//			// 默认球半径大小
//			if (isNaN(_radius) || _radius == 0)
//				_radius = DEFAULT_BALL_SIZE;
//			
//			super.createShape();
//		}
	}
}