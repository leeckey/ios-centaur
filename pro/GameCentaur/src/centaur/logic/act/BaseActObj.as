package centaur.logic.act
{
	import centaur.data.act.ActData;
	import centaur.data.card.CardData;
	import centaur.data.card.CardTemplateDataList;
	import centaur.data.combat.CombatData;
	import centaur.logic.action.SelectCardToCemeteryArea;
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
		public var enemyActObj:BaseActObj;
		
		public function BaseActObj(data:ActData)
		{
			this.actData = data;
			objID = UniqueNameFactory.getUniqueID(this);
			
			init();
		}
		
		public function resetCombatData():void
		{
			if (!combatData)
				combatData = new CombatData(this);
			combatData.reset(cardObjList);
			
			var len:int = cardObjList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var obj:BaseCardObj = cardObjList[i] as BaseCardObj;
				if (obj)
					obj.resetCombatData();
			}
			
			actData.hp = actData.maxHP;
		}
		
		protected function init():void
		{
			if (!actData)
				return;
			
			cardObjList = [];
			var len:int = actData.cardList ? actData.cardList.length : 0;
			for (var i:int = 0; i < len; ++i)
			{
				var cardData:CardData = actData.cardList[i] as CardData;
				var cardObj:BaseCardObj = new BaseCardObj(cardData, this);
				cardObjList.push(cardObj);
			}
		}
		
		/**
		 *   卡牌移动到墓地区
		 */ 
		public function cardToCemeteryArea(cardObj:BaseCardObj, list:Array):void
		{
			if (!cardObj)
				return;
			
			var combatData:CombatData = combatData;
			// 从战斗区,等待区或卡堆中移除
			var idx:int = combatData.selfCombatArea.indexOf(cardObj);
			if (idx > -1)
				combatData.selfCombatArea[idx] = null;	// 位置不变，回合结束后梳理
			else if ((idx = combatData.selfCardArea.indexOf(cardObj)) > -1)
				combatData.selfCardArea.splice(idx, 1);
			else if ((idx = combatData.selfWaitArea.indexOf(cardObj)) > -1)
				combatData.selfWaitArea.splice(idx, 1);
			
			// 添加到墓地区
			if (combatData.selfCemeteryArea.indexOf(cardObj) == -1)
				combatData.selfCemeteryArea.push(cardObj);
			
			// 添加相应操作数据
			var action:SelectCardToCemeteryArea = new SelectCardToCemeteryArea();
			action.ownerID = objID;
			action.targetObj = cardObj.objID;
			list.push(action);
		}
	}
}