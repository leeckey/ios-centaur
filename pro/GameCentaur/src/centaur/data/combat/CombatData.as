package centaur.data.combat
{
	/**
	 *   战斗先关数据
	 */ 
	public final class CombatData
	{
		public var selfCardArea:Array;			// 卡堆区
		public var selfWaitArea:Array;			// 等待区
		public var selfCombatArea:Array;		// 战斗区
		public var selfCemeteryArea:Array;		// 墓地区
		
		public function CombatData()
		{
		}
		
		public function reset(cardObjList:Array):void
		{
			selfCardArea = cardObjList ? cardObjList.concat() : [];
			selfWaitArea = [];
			selfCombatArea = [];
			selfCemeteryArea = [];
		}
		
		
	}
}