package centaur.data.combat
{
	import centaur.logic.act.BaseActObj;

	/**
	 *  战斗结果相关数据
	 */ 
	public final class CombatResultData
	{
		public var selfAct:BaseActObj;		// 参与战斗的2个Act
		public var targetAct:BaseActObj;
		
		public var result:int;				// 战斗结果
		public var combatActionList:Array;	// 战斗操作序列
	}
}