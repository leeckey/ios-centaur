package centaur.scene.entity.elements
{
	import Box2DAS.Common.V2;
	
	import com.citrusengine.objects.platformer.nape.Hero;

	public final class MainPlayer extends Hero
	{
		public function MainPlayer(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		public function jump():void
		{
//			if (_onGround)
//			{
//				var velocity:V2 = _body.GetLinearVelocity();
//				velocity.y -= this.jumpHeight + 10;
//				
//				_body.SetLinearVelocity(velocity);
//				this.updateAnimation();
//			}
		}
	}
}