package centaur.logic.combat
{
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.SelectCardToWaitAreaAction;

	/**
	 *   战斗的逻辑计算对象
	 */ 
	public class CombatLogicObj
	{
		public var selfAct:BaseActObj;			// 攻击者
		public var targetAct:BaseActObj;		// 受攻击者
		
		public function CombatLogicObj(selfAct:BaseActObj, targetAct:BaseActObj)
		{
			this.selfAct = selfAct;
			this.targetAct = targetAct;
			
			init();
		}
		
		protected function init():void
		{
			if (!selfAct)
				return;
			
			// 初始化自身的战斗区数据
			selfAct.resetCombatData();
		}
		
		/**
		 *   阶段前的全局技能,返回对应的操作数据
		 */ 
		public function preSkill(list:Array):Object
		{
			if (!selfAct)
				return;
			
			return null;	
		}
		
		/**
		 *  从卡堆随机一张到等待区域
		 */ 
		public function selectCardToWaitArea(list:Array):Object
		{
			if (!selfAct)
				return;
			
			// 随机从卡堆挑选一个进入等待区域
			var len:int = selfAct.combatData.selfCardArea.length;
			var ranIdx:int = len * Math.random();
			var cardObj:BaseCardObj = selfAct.combatData.selfCardArea[ranIdx];
			selfAct.combatData.selfCardArea.splice(ranIdx, 1);
			selfAct.combatData.selfWaitArea.push(cardObj);
			
			// 添加相应操作
			var action:SelectCardToWaitAreaAction = new SelectCardToWaitAreaAction();
			action.srcObj = selfAct.objID;
			action.targetObj = targetAct.objID;
			action.index = ranIdx;
			list.push(action);
			
			return null;
		}
		
		/**
		 *  从等待区选择无需等待卡到战斗区域
		 */ 
		public function selectCardToCombatArea(list:Array):Object
		{
			if (!selfAct)
				return;
			
			return null;
		}
		
		public function doCombat(list:Array):Object
		{
			if (!selfAct)
				return;
			
			return null;
			
		}
		
	}
}