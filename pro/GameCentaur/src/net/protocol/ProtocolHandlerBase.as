package net.protocol
{
	import centaur.data.GlobalAPI;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class ProtocolHandlerBase
	{
		private var _replyCallback:Function;
		
		public function ProtocolHandlerBase(reply:Function = null)
		{
			_replyCallback = reply;
		}
		
		public function get pCode():int
		{
			return 0;
		}
		
		public function get url():String
		{
			return "";
		}
		
		public function requestGet(params:Object):void
		{
			var vars:URLVariables = new URLVariables();
			if (params)
			{
				for (var key:* in params)
					vars[key] = params[key];
			}
			
			var request:URLRequest = new URLRequest(this.url);
			request.data = vars;
			
			GlobalAPI.httpManager.httpRequest(request, loadData);
		}
		
		protected function loadData(data:*):void
		{
			data = parserData(data);
			if (_replyCallback != null)
				_replyCallback(data);
		}
		
		private function parserData(data:*):*
		{
			var result:Object;
			if (data is String)
			{
				result = JSON.parse(data);
			}
			else if (data is Object)
				result = data;
			
			return result;
		}
			
	}
}