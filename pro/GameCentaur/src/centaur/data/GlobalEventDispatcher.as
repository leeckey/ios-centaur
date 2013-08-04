package centaur.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public final class GlobalEventDispatcher
	{
		public static const DETAIL_CARD_SHOW:String = "detailCardShow";
		public static const DETAIL_CARD_HIDE:String = "detailCardHide";
		
		public static const INS_COMBAT_HIDE:String = "INS_COMBAT_HIDE";
		
		private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
		
		public static function addEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.addEventListener(type, listener);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.removeEventListener(type, listener);
		}
		
		public static function dispatch(event:Event):void
		{
			_eventDispatcher.dispatchEvent(event);
		}
			
	}
}