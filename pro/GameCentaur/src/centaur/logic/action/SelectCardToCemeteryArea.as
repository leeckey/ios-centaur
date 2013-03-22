package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   将卡牌转移到墓地区操作
	 */ 
	public final class SelectCardToCemeteryArea extends ActionBase
	{
		public var ownerID:uint;
			
		public function SelectCardToCemeteryArea()
		{
			type = CombatLogic.ACTION_SELECT_TO_CEMETERYAREA;
		}
	}
}