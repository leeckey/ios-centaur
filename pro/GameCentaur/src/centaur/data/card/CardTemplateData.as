package centaur.data.card
{
	import centaur.utils.Utils;

	public final class CardTemplateData
	{
		public var templateID:uint;			// 模板ID
		public var name:String;				// 卡牌名称
		public var maxHP:uint;				    // 最大血量
		public var attack:uint;				// 基础攻击
		public var defense:uint;			    // 基础防御
		public var maxWaitRound:uint;		    // 等待区时的最大等待轮数
		public var starLv:uint;				// 卡牌的星级
		public var country:uint;               // 卡牌的势力
		
		// 按顺序放置 0级    5级   10级        
		public var skillList:Array = Utils.EMPTY_ARRAY;	// 卡牌拥有的技能ID列表
		
		public function CardTemplateData()
		{
		}
		
	}
}