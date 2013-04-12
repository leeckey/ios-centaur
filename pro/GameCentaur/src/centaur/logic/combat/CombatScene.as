package centaur.logic.combat
{
	import centaur.data.combat.CombatResultData;
	import centaur.logic.act.BaseActObj;

	public final class CombatScene
	{
		public var selfAct:BaseActObj;
		public var targetAct:BaseActObj;
		public var logic:CombatLogic;
		
		public function CombatScene(selfAct:BaseActObj, targetAct:BaseActObj)
		{
			this.selfAct = selfAct;
			this.targetAct = targetAct;
			logic = new CombatLogic();
		}
		
		public function start():CombatResultData
		{
			if (!selfAct || !targetAct)
				return null;
			
			selfAct.scene = targetAct.scene = this;
			var res:CombatResultData = logic.combat(selfAct, targetAct);
			selfAct.scene = targetAct.scene = null;
			return res;
		}
	}
}