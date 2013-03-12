package centaur.logic.act
{
	import centaur.data.card.CardData;
	import centaur.logic.render.BaseCardRender;
	import centaur.utils.UniqueNameFactory;

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
	}
}