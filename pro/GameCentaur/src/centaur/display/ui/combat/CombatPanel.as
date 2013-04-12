package centaur.display.ui.combat
{
	import centaur.data.GlobalAPI;
	import centaur.data.combat.CombatResultData;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.display.ui.combat.handler.ActionHandlerManager;
	import centaur.interfaces.ITick;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	
	import combat.CombatPanelAsset;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GText;

	public final class CombatPanel extends GBuilderBase implements ITick
	{
		public var roundNum:GText;
		public var selfPanel:CombatActPanel;
		public var targetPanel:CombatActPanel;
		private var _panelDic:Dictionary;
		
		public var resultData:CombatResultData;
		private var _handlerIdx:int;
		private var _lagTime:int;
		private var _startTime:int;
		
		private static var _instance:CombatPanel;
		public static function get instance():CombatPanel
		{
			return _instance ? _instance : (_instance = new CombatPanel());
		}
		
		public function CombatPanel()
		{
			super(CombatPanelAsset);
		}
		
		public function startPlay(resultData:CombatResultData):void
		{
			this.resultData = resultData;
			if (!resultData || !resultData.selfAct || !resultData.targetAct)
				return;
			
			// 角色与面板相绑定，方便查找
			_panelDic = new Dictionary;
			_panelDic[resultData.selfAct.objID] = selfPanel;
			_panelDic[resultData.targetAct.objID] = targetPanel;
			selfPanel.data = resultData.selfAct;
			targetPanel.data = resultData.targetAct;
			
			// 添加帧频
			_handlerIdx = _lagTime = 0;
			_handlerIdx = -1;
			_startTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function getActPanelByID(id:uint):CombatActPanel
		{
			return _panelDic ? _panelDic[id] as CombatActPanel : null;
		}
		
		public function update(times:int, delta:int):void
		{
			if (!resultData)
			{
				GlobalAPI.tickManager.removeTick(this);
				return;
			}
			
			_startTime += delta;
			if (_startTime < _lagTime)
				return;
			_startTime = 0;
			
			// 动作处理完，战斗结束
			_handlerIdx++;
			if (_handlerIdx >= resultData.combatActionList.length)
			{
				onCombatComplete();
				return;
			}
			
			// 间隔一段时间处理下一个动作
			var actionBase:ActionBase = resultData.combatActionList[_handlerIdx] as ActionBase;
			if (actionBase)
			{
				var actionHandler:ActionHandler = GlobalAPI.actionHandlerManager.handle(actionBase);
				_lagTime = actionHandler.castTime;
			}
			else
				_lagTime = 0;
		}
		
		private function onCombatComplete():void
		{
			
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			this.destory();
		}
		
		public function onRoundStart(round:int):void
		{
			roundNum.text = "回合:" + round;
		}
		
		public function onRoundEnd(round:int):void
		{
			selfPanel.onRoundEnd();
			targetPanel.onRoundEnd();
		}
		
		public function addCardToWaitArea(srcID:uint, cardObj:BaseCardObj):void
		{
			var actPanel:CombatActPanel = getActPanelByID(srcID);
			if (actPanel)
				actPanel.addCardToWaitArea(cardObj);
		}
		
		public function addCardToCombatArea(srcID:uint, cardObj:BaseCardObj):void
		{
			var actPanel:CombatActPanel = getActPanelByID(srcID);
			if (actPanel)
				actPanel.addCardToCombatArea(cardObj);
		}
		
		public function addCardToCemeteryArea(srcID:uint, cardObj:BaseCardObj):void
		{
			var actPanel:CombatActPanel = getActPanelByID(srcID);
			if (actPanel)
				actPanel.addCardToCemeteryArea(cardObj);
		}
		
	}
}