package centaur.logic.act
{
	import centaur.data.card.CardData;
	import centaur.data.card.CardTemplateData;
	import centaur.data.card.CardTemplateDataList;
	import centaur.logic.render.BaseCardRender;
	import centaur.utils.UniqueNameFactory;

	/**
	 *   卡牌数据对象
	 */ 
	public class BaseCardObj
	{
		public var objID:uint;
		
		public var cardData:CardData;
		public var render:BaseCardRender;
		
		public function BaseCardObj(data:CardData)
		{
			this.cardData = data;
			objID = UniqueNameFactory.getUniqueID(this);
		}
		
		public function resetCombatData():void
		{
			if (cardData)
			{
				var templateData:CardTemplateData = CardTemplateDataList.getCardData(cardData.templateID);
				if (templateData)
				{
					cardData.hp = cardData.maxHP;
					cardData.waitRound = templateData.maxWaitRound;
				}
			}
		}
		
		public function get waitRound():int
		{
			return cardData ? cardData.waitRound : 0;
		}
	}
}