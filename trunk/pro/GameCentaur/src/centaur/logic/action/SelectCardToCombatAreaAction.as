package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   选择卡牌到战斗队列的操作
	 */ 
	public final class SelectCardToCombatAreaAction extends ActionBase
	{
		// 卡牌ID
		public var cardID:int;
		
		public function SelectCardToCombatAreaAction()
		{
			type = CombatLogic.ACTION_SELECT_TO_COMBATAREA;
		}
	}
}