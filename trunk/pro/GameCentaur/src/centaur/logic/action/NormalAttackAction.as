package centaur.logic.action
{
	import centaur.logic.combat.CombatLogic;

	/**
	 *   普通攻击操作
	 */ 
	public final class NormalAttackAction extends ActionBase
	{
		public var damage:int;
		
		public function NormalAttackAction()
		{
			type = CombatLogic.ACTION_ATTACK;
		}
	}
}