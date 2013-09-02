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
		public var uin:String;					// 唯一ID
		public var sKey:String;					// 登陆状态临时分配Key值
		
		public var heroHP:int;					// 英雄血量
		public var cost:int;					// 卡牌总cost值
		public var cardTeam:int;				// 当前卡组号
		public var totalAttack:int;				// 总攻击力
		public var totalBody:int;				// 体力
		
		public function PlayerInfo()
		{
		}
	}
}