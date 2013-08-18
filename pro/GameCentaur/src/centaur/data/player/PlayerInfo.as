package centaur.data.player
{
	/**
	 *   角色信息类
	 */ 
	public final class PlayerInfo
	{
		public var id:uint;
		public var accountID:String;	// 可能用手机MAC地址
		public var name:String;
		public var sex:Boolean;	// true male  false female
		public var lv:int;
		
		public function PlayerInfo()
		{
		}
	}
}