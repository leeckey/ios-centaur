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
		
		public var allCardArea:Array;          // 所有卡牌
		
		public function CombatData(owner:BaseActObj)
		{
			this.owner = owner;
		}
		
		public function reset(cardObjList:Array):void
		{
			allCardArea = cardObjList ? cardObjList.concat() : [];
			selfCardArea = cardObjList ? cardObjList.concat() : [];
			selfWaitArea = [];
			selfCombatArea = [];
			selfCemeteryArea = [];
		}
		
		/**
		 * 获得某一国家的全部卡牌 
		 * @param country
		 * 
		 */		
		public function getCardByCountry(country:int):Array
		{
			var res:Array = [];
			var target:BaseCardObj;
			for (var i:int = 0; i < allCardArea.length; i++)
			{
				target = allCardArea[i] as BaseCardObj;
				if (target != null && target.cardData.country == country)
					res.push(target);
			}
			return res;
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
		
		/**
		 * 获得战斗区中的所有卡牌
		 * @return 
		 * 
		 */		
		public function getAllCombatAreaCard():Array
		{
			var res:Array = [];
			for (var i:int = 0; i < selfCombatArea.length; ++i)
			{
				var target:BaseCardObj = selfCombatArea[i];
				if (target)
					res.push(target);
			}
			
			return res;
		}
		
		/**
		 * 随机三张卡牌 
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 血量最少的卡牌 
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 失血最多的卡牌 
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 获得所有可以治疗的卡牌 
		 * @return 
		 * 
		 */		
		public function getCardFromCombatAreaCanCure():Array
		{
			var res:Array = [];
			
			for (var i:int = 0; i < selfCombatArea.length; ++i)
			{
				var target:BaseCardObj = selfCombatArea[i];
				if (target && (target.cardData.maxHP != target.hp))
				{
					res.push(target);
				}
			}
			
			return res;
		}
	}
}