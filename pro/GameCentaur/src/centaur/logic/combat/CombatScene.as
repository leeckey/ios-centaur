package centaur.logic.combat
{
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
		
		public function start():Object
		{
			if (!selfAct || !targetAct)
				return null;
			
			selfAct.scene = targetAct.scene = this;
			var res:Object = logic.combat(selfAct, targetAct);
			selfAct.scene = targetAct.scene = null;
			return res;
		}
	}
}