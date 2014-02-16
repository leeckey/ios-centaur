package centaur.data.act
{
	

	/**
	 *   角色数据
	 */ 
	public class HeroData extends ActData
	{
		public var name:String;				// 名称
		public var lv:uint;					// 等级
		public var sex:int;					// 性别
		public var country:int;				// 国家
		public var mobility:uint;			// 行动力
		
		public var money:uint;				// 金钱，后续扩展
		
		private var _combatCardIdxList:Array;		// 派上场战斗的卡牌索引列表
		
		public function HeroData()
		{
		}
		
		public function set combatCardIdxList(val:Array):void
		{
			_combatCardIdxList = val;
			
		}
		
		public function get combatCardIdxList():Array
		{
			return _combatCardIdxList;
		}
		
		override public function getCombatCardList():Array
		{
			if (!_combatCardIdxList || !_combatCardIdxList.length)
				return this.cardList;
			
			var list:Array = [];
			for (var i:int = 0; i < _combatCardIdxList.length; ++i)
			{
				var card:* = cardList[_combatCardIdxList[i]];
				if (card)
					list.push(card);
			}
			return list;
		}
	}
}