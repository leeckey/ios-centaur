package centaur.logic.combat
{
	import centaur.data.act.ActData;
	import centaur.data.combat.CombatResultData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.RoundEndAction;
	import centaur.logic.action.RoundStartAction;

	public final class CombatLogic
	{
		public static var combatList:Array;
		private var _selfAct:BaseActObj;
		private var _targetAct:BaseActObj;
		
		public function CombatLogic()
		{
		}
		
		/**
		 *   计算两组卡牌数据
		 */ 
		public function combat(selfAct:BaseActObj, targetAct:BaseActObj):CombatResultData
		{
			_selfAct = selfAct;
			_selfAct.enemyActObj = targetAct;
			_selfAct.resetCombatData();
			_targetAct = targetAct;
			_targetAct.enemyActObj = selfAct;
			_targetAct.resetCombatData();
			
			// 未分胜负，继续战斗
			var combatResult:int;
			combatList = [];
			var round:uint;
			while (!(combatResult = checkWin()) && round <= 200)
			{
				// 当前新回合
				round++;
				
				combatList.push(RoundStartAction.getAction(round));
				
				var curAct:BaseActObj = ((round % 2) != 0) ? _selfAct : _targetAct;
				
				// 回合前阶段
				curAct.preSkill();
				
				// 随机抽卡
				curAct.selectCardToWaitArea();
				
				// 从等待区选卡到战斗区
				curAct.selectCardToCombatArea();
				
				// 攻击对方,true时直接已经分出胜负，无需继续
				if (curAct.doCombat())
				{
					combatResult = checkWin();
					break;
				}
				
				// 当前回合结束
				selfAct.roundEndCallback();
				targetAct.roundEndCallback();
				combatList.push(RoundEndAction.getAction(round));
			}
			
			var resultData:CombatResultData = new CombatResultData();
			resultData.selfAct = selfAct;
			resultData.targetAct = targetAct;
			resultData.result = combatResult;
			resultData.combatActionList = combatList;
			return resultData;
		}
		
		/**
		 *   每回合判断胜负函数,1 0 -1。1表示self赢,0未分胜负，-1target赢
		 */ 
		private function checkWin():int
		{
			if (_selfAct.checkIsWin())
				return 1;
			if (_targetAct.checkIsWin())
				return -1
			
	 		return 0;
		}
	}
}