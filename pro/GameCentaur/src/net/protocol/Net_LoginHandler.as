package net.protocol
{
	/**
	 *   
	 */ 
	public final class Net_LoginHandler extends ProtocolHandlerBase
	{
		public function Net_LoginHandler(reply:Function = null)
		{
			super(reply);
		}
		
		override public function get pCode():int
		{
			return ProtocolType.PROTOCOL_LOGIN;
		}
		
		override public function get url():String
		{
			return "http://tyfeng.duapp.com/php/login.php";
		}
		
		/**
		 *   手动登陆
		 */ 
		public function manualLogin(name:String, pwd:String):void
		{
			var params:Object = {};
			params.name = name;
			params.pwd = pwd;
			
			this.requestGet(params);
		}
		
		override protected function loadData(data:*):void
		{
			var result:Object = data as Object;
			super.loadData(data);
		}
	}
}