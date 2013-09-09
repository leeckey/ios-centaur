package net.protocol
{
	

	/**
	 *   注册消息处理
	 */ 
	public final class Net_RegisterHandler extends ProtocolHandlerBase
	{
		public function Net_RegisterHandler(reply:Function = null)
		{
			super(reply);
		}
		
		override public function get pCode():int
		{
			return ProtocolType.PROTOCOL_REGISTER;
		}
		
		override public function get url():String
		{
			return "http://tyfeng.duapp.com/php/register.php";
		}
		
		/**
		 *   设备快捷注册
		 */ 
		public function fastRegisterOrLogin(device:String):void
		{
			var params:Object = {};
			params.type = 1;
			params.device = device;
			
			this.requestGet(params);
		}
		
		/**
		 *   手动注册
		 */ 
		public function manualRegister(name:String, pwd:String):void
		{
			var params:Object = {};
			params.type = 2;
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