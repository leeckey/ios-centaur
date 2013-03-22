package centaur.logic.combat
{
	import centaur.data.act.ActData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.action.RoundEndAction;
	import centaur.logic.action.RoundStartAction;

	public final class CombatLogic
	{
		public static const ACTION_SELECT_TO_WAITAREA:int = 1;		// 从卡堆移动卡牌到等待区
		public static const ACTION_SELECT_TO_COMBATAREA:int = 2;	// 从等待区移动卡牌到战斗区
		public static const ACTION_SELECT_TO_CEMETERYAREA:int = 3;	// 将卡牌移动到墓地区
		public static const ACTION_ATTACK_EFFECT:int = 4;			// 普通效果
		public static const ACTION_SKILL_EFFECT:int = 5;			// 技能效果
		public static const ACTION_PRESKILL:int = 6;				// 回合前阶段技能
		public static const ACTION_ROUND_START:int = 7;				// 新回合开始
		public static const ACTION_ROUND_END:int = 8;				// 当前回合结束
		public static const ACTION_DAMAGE_NOTIFY:int = 9;			// 专门处理伤害的操作类型
		public static const ACTION_BUFF_NOTIFY:int = 10;			// BUFF操作类型
		
		public static var combatList:Array;
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
			combatList = [];
			var round:uint;
			while (!(combatResult = checkWin()))
			{
				// 当前新回合
				round++;
				addRoundStart(round, combatList);
				var curLogic:CombatLogicObj = ((round % 2) != 0) ? _selfLogic : _targetLogic;
				
				// 回合前阶段
				curLogic.preSkill(combatList);
				
				// 随机抽卡
				curLogic.selectCardToWaitArea(combatList);
				
				// 从等待区选卡到战斗区
				curLogic.selectCardToCombatArea(combatList);
				
				// 攻击对方,true时直接已经分出胜负，无需继续
				if (curLogic.doCombat(combatList))
					break;
				
				// 当前回合结束
				_selfLogic.roundEndCallback();
				_targetLogic.roundEndCallback();
				addRoundEnd(round, combatList);
			}
			
			return {combatResult : combatResult, combatList : combatList};
		}
		
		/**
		 *   每回合判断胜负函数,1 0 -1。1表示self赢,0未分胜负，-1target赢
		 */ 
		private function checkWin():int
		{
			if (_selfLogic.checkIsWin())
				return 1;
			if (_targetLogic.checkIsWin())
				return -1
			
	 		return 0;
		}
		
		private function addRoundStart(round:uint, list:Array):void
		{
			var action:RoundStartAction = new RoundStartAction();
			action.round = round;
			list.push(action);
		}
		
		private function addRoundEnd(round:uint, list:Array):void
		{
			var action:RoundEndAction = new RoundEndAction();
			action.round = round;
			list.push(action);
		}
	}
}