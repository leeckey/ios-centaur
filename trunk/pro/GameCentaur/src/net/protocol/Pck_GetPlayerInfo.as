package net.protocol
{
	public final class Pck_GetPlayerInfo extends ProtocolHandlerBase
	{
		public function Pck_GetPlayerInfo(reply:Function = null)
		{
			super(reply);
		}
		
		override public function get pCode():int
		{
			return ProtocolType.PROTOCOL_GET_INFO;
		}
		
		override public function get url():String
		{
			return "http://tyfeng.duapp.com/php/getbaseinfo.php";
		}
		
		public function requestGetPlayerInfo(uin:String, skey:String):void
		{
			var params:Object = {};
			params.uin = uin;
			params.skey = skey;
			
			this.requestGet(params);
		}
	}
}