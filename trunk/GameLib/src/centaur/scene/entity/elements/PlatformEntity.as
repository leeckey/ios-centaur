package centaur.scene.entity.elements
{
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionType;
	import nape.callbacks.PreCallback;
	import nape.callbacks.PreFlag;
	import nape.callbacks.PreListener;
	import nape.geom.Vec2;
	import nape.phys.BodyType;

	public class PlatformEntity extends EntityBase
	{
		public static const ONEWAY_PLATFORM:CbType = new CbType();
		
		private var _oneWay:Boolean = false;
		private var _preListener:PreListener;
		
		public function PlatformEntity(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		override public function destroy():void
		{
			if (_body.cbTypes.length > 0) {
				_body.cbTypes.clear();
			}
			if (_preListener) {
				_preListener.space = null;
				_preListener = null;
			}
			
			super.destroy();
		}
		
		override protected function updateProperties():void
		{
			super.updateProperties();
			
			if (_data)
			{
				oneWay = _data.oneWay;
			}
		}
		
		/**
		 * Makes the platform only collidable when falling from above it.
		 */
		public function get oneWay():Boolean
		{
			return _oneWay;
		}
		
		[Property(value="false")]
		public function set oneWay(value:Boolean):void
		{
			if (_oneWay == value)
				return;
			
			_oneWay = value;
			
			if (_oneWay)
			{
				_preListener = new PreListener(InteractionType.ANY, PlatformEntity.ONEWAY_PLATFORM, CbType.ANY_BODY, handlePreContact);
				_body.space.listeners.add(_preListener);
				_body.cbTypes.add(ONEWAY_PLATFORM);
			}
			else
			{
				if (_preListener) {
					_preListener.space = null;
					_preListener = null;
				}
				_body.cbTypes.clear();
			}
		}
		
		override protected function defineBody():void {
			_bodyType = BodyType.STATIC;
			
			if (_oneWay) {
				_preListener = new PreListener(InteractionType.COLLISION, ONEWAY_PLATFORM, CbType.ANY_BODY, this.handlePreContact);
			}
		}
		
		override protected function createBody():void 
		{
			super.createBody();
			if (_oneWay) {
				_body.cbTypes.add(ONEWAY_PLATFORM);
			}
			
		}
		
		override protected function createConstraint():void {
			super.createConstraint();
			
			if (_preListener) {
				_body.space.listeners.add(_preListener);
			}
		}
		
		override public function handlePreContact(callback:PreCallback):PreFlag
		{
			var dir:Vec2 = new Vec2(0, callback.swapped ? 1 : -1);
			
			if (dir.dot(callback.arbiter.collisionArbiter.normal) >= 0) {
				return null;
			} else {
				return PreFlag.IGNORE;
			}
		}
	}
}