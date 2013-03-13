package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   选择卡牌到等待队列的操作
	 */ 
	public final class SelectCardToWaitAreaAction extends ActionBase
	{
		// 卡牌ID
		public var cardID:int;
		
		public function SelectCardToWaitAreaAction()
		{
			type = CombatLogic.ACTION_SELECT_TO_WAITAREA;
		}
	}
}