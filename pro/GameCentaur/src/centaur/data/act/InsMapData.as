package centaur.data.act
{
	/**
	 *   副本地图数据，有一些副本胜利条件数据
	 */ 
	public final class InsMapData extends ActData
	{
		public static const INS_SIMPLE_TYPE:int = 1;
		public static const INS_NORMAL_TYPE:int = 2;
		public static const INS_HARD_TYPE:int = 3;
		
		public var name:String;				// 名称
		public var lv:uint;					// 等级
//		public var curStarLv:int;			// 当前星级 		保存于角色数据内为好
		public var needMobility:int;		// 消耗行动力
		
		public function InsMapData()
		{
		}
	}
}