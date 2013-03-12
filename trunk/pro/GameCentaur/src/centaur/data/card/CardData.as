package centaur.data.card
{
	/**
	 *   卡牌数据
	 */ 
	public final class CardData
	{
		public var templateID:uint;			// 模板ID
		public var name:String;				// 卡牌名称
		public var lv:uint;					// 卡牌等级
		public var hp:uint;					// 当前血量
		public var maxHP:uint;				// 最大血量
		public var attack:uint;				// 基础攻击
		public var defense:uint;			// 基础防御
		public var waitRound:uint;			// 等待区时的等待轮数
		
		// 按顺序放置 0级    5级   10级        
		public var skillList:Array;			// 卡牌拥有的技能ID列表
		
		public function CardData()
		{
		}
	}
}