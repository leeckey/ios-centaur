package centaur.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public final class GlobalEventDispatcher
	{
		public static const DETAIL_CARD_SHOW:String = "detailCardShow";
		public static const DETAIL_CARD_HIDE:String = "detailCardHide";
		
		public static const INS_COMBAT_HIDE:String = "INS_COMBAT_HIDE";
		
		public static const INS_COMBAT_COMPLETE:String = "insCombatComplete";
		public static const MAP_COMBAT_COMPLETE:String = "mapCombatComplete";
		
		private static var _eventDispatcher:ManualEventDispatcher;
		
		public static function addEventListener(type:String, listener:Function):void
		{
			if (!_eventDispatcher)
				_eventDispatcher = new ManualEventDispatcher();
			_eventDispatcher.addEventListener(type, listener);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			if (!_eventDispatcher)
				_eventDispatcher = new ManualEventDispatcher();
			_eventDispatcher.removeEventListener(type, listener);
		}
		
		public static function dispatch(event:Event, data:* = null):void
		{
			if (!_eventDispatcher)
				_eventDispatcher = new ManualEventDispatcher();
			_eventDispatcher.data = data;
			_eventDispatcher.dispatchEvent(event);
		}
			
	}
}
import flash.events.Event;
import flash.events.EventDispatcher;

class ManualEventDispatcher extends EventDispatcher
{
	public var data:* = null;
	
	public function ManualEventDispatcher():void
	{
		super();
	}
	
}