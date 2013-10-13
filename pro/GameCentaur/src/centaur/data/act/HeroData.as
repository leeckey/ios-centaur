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
		
		public var combatCardIdxList:Array;		// 派上场战斗的卡牌索引列表
		
		public function HeroData()
		{
		}
	}
}