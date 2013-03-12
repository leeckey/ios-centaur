package centaur.logic.act
{
	import centaur.data.act.ActData;
	import centaur.data.card.CardDataList;
	import centaur.data.combat.CombatData;
	import centaur.logic.render.BaseActRender;
	import centaur.utils.UniqueNameFactory;

	/**
	 *  战斗目标的数据对象，类似于纯数据和显示对象的中间控制层
	 */ 
	public class BaseActObj
	{
		public var objID:uint;
		
		public var actData:ActData;
		public var render:BaseActRender;
		public var cardObjList:Array;
		
		public var combatData:CombatData;
		
		public function BaseActObj(data:ActData)
		{
			this.actData = data;
			objID = UniqueNameFactory.getUniqueID(this);
			
			init();
		}
		
		public function resetCombatData():void
		{
			if (!combatData)
				combatData = new CombatData();
			combatData.reset(cardObjList);
		}
		
		protected function init():void
		{
			if (!actData)
				return;
			
			cardObjList = [];
			var len:int = actData.cardList ? actData.cardList.length : 0;
			for (var i:int = 0; i < len; ++i)
			{
				var cardID:uint = actData.cardList[i] as uint;
				var cardObj:BaseCardObj = new BaseCardObj(CardDataList.getCardData(cardID));
				cardObjList.push(cardObj);
			}
			
			
			
		}
	}
}