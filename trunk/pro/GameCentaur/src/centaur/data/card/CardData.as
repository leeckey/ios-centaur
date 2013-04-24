package centaur.data.card
{
	/**
	 *   卡牌数据
	 */ 
	public final class CardData
	{
		public var templateID:uint;			// 模板ID
		public var lv:uint;					// 卡牌等级
		public var maxHP:uint;				    // 最大血量
		public var attack:uint;				// 基础攻击
		public var defense:uint;			    // 基础防御
		public var waitRound:uint;			    // 等待区时的等待轮数
		public var country:int;                // 卡牌所属势力
		
		public function CardData()
		{
		}
		
		public function update():void
		{
			// 根据等级以及配置表，刷新当前数据
			var templateData:CardTemplateData = CardTemplateDataList.getCardData(templateID);
			if (!templateData)
				return;
			
			// 等级提升计算后续添加
			this.maxHP = templateData.maxHP;
			this.attack = templateData.attack;
			this.defense = templateData.defense;
			this.waitRound = templateData.maxWaitRound;
			this.country = templateData.country;
		}
	}
}