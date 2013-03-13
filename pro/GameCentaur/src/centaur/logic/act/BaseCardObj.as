package centaur.logic.act
{
	import centaur.data.card.CardData;
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
				cardData.hp = cardData.maxHP;
				cardData.waitRound = cardData.maxWaitRound;
			}
		}
		
		public function get waitRound():int
		{
			return cardData ? cardData.waitRound : 0;
		}
	}
}