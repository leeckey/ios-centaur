package centaur.logic.combat
{
	import centaur.data.act.ActData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.action.AddRoundAction;

	public final class CombatLogic
	{
		public static const ACTION_SELECT_TO_WAITAREA:int = 1;		// 从卡堆移动卡牌到等待区
		public static const ACTION_SELECT_TO_COMBATAREA:int = 2;	// 从等待区移动卡牌到战斗区
		public static const ACTION_ATTACK:int = 3;					// 普通攻击
		public static const ACTION_SKILL:int = 4;					// 技能攻击
		public static const ACTION_PRESKILL:int = 5;				// 回合前阶段技能
		public static const ACTION_DEAD_REMOVE:int = 6;				// 从战斗区移动卡牌到墓地区
		public static const ACTION_ROUND_ADD:int = 7;				// 新回合开始
		
		private var _selfLogic:CombatLogicObj;
		private var _targetLogic:CombatLogicObj;
		
		public function CombatLogic()
		{
		}
		
		/**
		 *   计算两组卡牌数据
		 */ 
		public function combat(selfAct:BaseActObj, targetAct:BaseActObj):Object
		{
			_selfLogic = new CombatLogicObj(selfAct, targetAct);
			_targetLogic = new CombatLogicObj(targetAct, selfAct);
			
			// 未分胜负，继续战斗
			var combatResult:int;
			var combatList:Array = [];
			var round:uint;
			while (!(combatResult = checkWin()))
			{
				// 当前新回合
				round++;
				addRound(round, combatList);
				var curLogic:CombatLogicObj = ((round % 2) != 0) ? _selfLogic : _targetLogic;
				
				// 回合前阶段
				curLogic.preSkill(combatList);
				
				// 随机抽卡
				curLogic.selectCardToWaitArea(combatList);
				
				// 从等待区选卡到战斗区
				curLogic.selectCardToCombatArea(combatList);
				
				// 攻击对方
				curLogic.doCombat(combatList);
			}
			
			return {combatResult : combatResult, combatList : combatList};
		}
		
		/**
		 *   每回合判断胜负函数,1 0 -1。1表示self赢,0未分胜负，-1target赢
		 */ 
		private function checkWin():int
		{
	 		return 1;	
		}
		
		private function addRound(round:uint, list:Array):void
		{
			var action:AddRoundAction = new AddRoundAction();
			action.round = round;
			list.push(action);
		}
	}
}