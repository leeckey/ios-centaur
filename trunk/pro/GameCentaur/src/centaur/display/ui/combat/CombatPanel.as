package centaur.display.ui.combat
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.GlobalEventDispatcher;
	import centaur.data.combat.CombatResultData;
	import centaur.display.control.GBitmapNumberText;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.display.ui.combat.handler.ActionHandlerManager;
	import centaur.display.ui.map.InsCombatPanel;
	import centaur.interfaces.ITick;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.utils.NumberType;
	
	import combat.CombatPanelAsset;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GText;

	/**
	 *   整个战斗面板
	 *   @author wangq 2013.04.13
	 */ 
	public final class CombatPanel extends GBuilderBase implements ITick
	{
		public var roundNum:GBitmapNumberText;				// 回合信息
		public var selfPanel:CombatActPanel;	// 己方面板
		public var targetPanel:CombatActPanel;	// 敌方面板
		private var _panelDic:Dictionary;		// 面板的映射
		public var resultData:CombatResultData;	// 战斗数据
		
		// 处理操作相关参数
		private var _handlerIdx:int;
		private var _lagTime:int;
		private var _startTime:int;
		private var _combatPaused:Boolean;
		
		private static var _instance:CombatPanel;
		public static function get instance():CombatPanel
		{
			return _instance ? _instance : (_instance = new CombatPanel());
		}
		
		public function CombatPanel()
		{
			super(CombatPanelAsset);
			
			setup();
		}
		
		private function setup():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
//			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			GlobalEventDispatcher.addEventListener(GlobalEventDispatcher.DETAIL_CARD_SHOW, onDetailShow);
			GlobalEventDispatcher.addEventListener(GlobalEventDispatcher.DETAIL_CARD_HIDE, onDetailHide);
		}
		
		private function onRemoveToStage(e:Event):void	
		{
			GlobalEventDispatcher.removeEventListener(GlobalEventDispatcher.DETAIL_CARD_SHOW, onDetailShow);
			GlobalEventDispatcher.removeEventListener(GlobalEventDispatcher.DETAIL_CARD_HIDE, onDetailHide);
		}
		
		private function onDetailShow(e:Event):void
		{
			this.visible = false;
			_combatPaused = true;
		}
		
		private function onDetailHide(e:Event):void
		{
			this.visible = true;
			_combatPaused = false;
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
		
		public function isSelfCard(cardObj:BaseCardObj):Boolean
		{
			return (resultData && cardObj.owner) ? (resultData.selfAct.objID == cardObj.owner.objID) : false;
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
			if (_combatPaused)
				return;
			
			_startTime += delta;
			if (_startTime < _lagTime)
				return;
			_startTime = 0;
			
			// 动作处理完，战斗结束
			_handlerIdx++;
			if (_handlerIdx >= resultData.combatActionList.length)
			{
				GlobalAPI.tickManager.removeTick(this);
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
			GlobalAPI.timerManager.startDelayCall(2000, backToMainPanel, 1);
		}
		
		private function backToMainPanel():void
		{
			if (parent)
				parent.removeChild(this);
			onRemoveToStage(null);
			clear();
			
			GlobalAPI.layerManager.returnLastModule();	// 返回上级面板
		}
		
		private function clear():void
		{
			if (selfPanel)
				selfPanel.clear();
			if (targetPanel)
				targetPanel.clear();
			onRoundStart(1);
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			this.destory();
		}
		
		public function onRoundStart(round:int):void
		{
			if (roundNum)
				roundNum.setNumber(round, NumberType.MIDDLE_WHITE_NUMBER);
		}
		
		public function onRoundEnd(round:int):void
		{
			targetPanel.onRoundEnd();
			selfPanel.onRoundEnd();
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