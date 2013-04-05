package centaur.data.combat
{
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;

	/**
	 *   战斗相关数据
	 */ 
	public final class CombatData
	{
		public var owner:BaseActObj;
		
		public var selfCardArea:Array;			// 卡堆区
		public var selfWaitArea:Array;			// 等待区
		public var selfCombatArea:Array;		// 战斗区
		public var selfCemeteryArea:Array;		// 墓地区
		
		public function CombatData(owner:BaseActObj)
		{
			this.owner = owner;
		}
		
		public function reset(cardObjList:Array):void
		{
			selfCardArea = cardObjList ? cardObjList.concat() : [];
			selfWaitArea = [];
			selfCombatArea = [];
			selfCemeteryArea = [];
		}
		
		/**
		 *   从战斗区获取一张存在的卡牌
		 */ 
		public function getCardFromCombatArea():BaseCardObj
		{
			for (var i:int = 0; i < selfCombatArea.length; ++i)
			{
				var target:BaseCardObj = selfCombatArea[i];
				if (target)
					return target;
			}
			
			return null;
		}
		
		public function getCardFromCombatAreaRandom3():Array
		{
			var res:Array = [];
			var len:int = selfCombatArea.length;
			for (var i:int = 0; i < len; ++i)
			{
				var target:BaseCardObj = selfCombatArea[i];
				if (target)
				{
					if (res.length >= 3)
					{
						var replaceIdx:int = Math.random() * 6;
						if (replaceIdx <= 2)
							res[replaceIdx]	 = target;	
					}
					else
						res.push(target);
				}
			}
			
			return res;
		}
		
		public function getCardFromCombatAreaMinHP():BaseCardObj
		{
			var minHP:int = int.MAX_VALUE;
			var res:BaseCardObj = null;
			for (var i:int = 0; i < selfCombatArea.length; ++i)
			{
				var target:BaseCardObj = selfCombatArea[i];
				if (target && minHP > target.hp)
				{
					minHP = target.hp;
					res = target;
				}
			}
			
			return res;
		}
		
		public function getCardFromCombatAreaMaxLoseHP():BaseCardObj
		{
			var max:int = 0;
			var res:BaseCardObj = null;
			for (var i:int = 0; i < selfCombatArea.length; ++i)
			{
				var target:BaseCardObj = selfCombatArea[i];
				if (target && max < (target.cardData.maxHP - target.hp))
				{
					max = (target.cardData.maxHP - target.hp);
					res = target;
				}
			}
			
			return res;
		}
		
	}
}