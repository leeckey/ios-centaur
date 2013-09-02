package net
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public final class HttpNetManager
	{
		public function HttpNetManager()
		{
			init();
		}
		
		private function init():void
		{
			
		}
		
		public function httpRequest(request:URLRequest, callback:Function = null):void
		{
			if (!request)
				return;
			
			var onRequestComplete:Function = function(e:Event):void
			{
				if (callback != null)
					callback((e.currentTarget as URLLoader).data);
			};
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onRequestComplete);
			loader.load(request);
		}
	}
}