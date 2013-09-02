package net.protocol
{
	import centaur.data.GlobalAPI;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class ProtocolHandlerBase
	{
		public function ProtocolHandlerBase()
		{
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
			
		}
	}
}