package net.protocol
{
	public final class Pck_SetPlayerInfo extends ProtocolHandlerBase
	{
		public function Pck_SetPlayerInfo(reply:Function = null)
		{
			super(reply);
		}
		
		override public function get pCode():int
		{
			return ProtocolType.PROTOCOL_SET_INFO;
		}
		
		override public function get url():String
		{
			return "http://tyfeng.duapp.com/php/setbaseinfo.php";
		}
		
		public function requestSetPlayerInfo(uin:String, skey:String, name:String, icon:int, sex:int):void
		{
			var params:Object = {};
			params.uin = uin;
			params.skey = skey;
			params.nickname = name;
			params.icon = icon;
			params.sex = sex;
			
			this.requestGet(params);
		}
	}
}