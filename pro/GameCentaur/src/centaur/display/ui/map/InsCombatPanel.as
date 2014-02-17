package centaur.display.ui.map
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.GlobalEventDispatcher;
	import centaur.data.act.ActData;
	import centaur.data.act.InsMapData;
	import centaur.data.act.InsMapDataList;
	import centaur.data.combat.CombatResultData;
	import centaur.display.ui.role.RoleCardPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.ToolTipSprite;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;

	public final class InsCombatPanel extends GBuilderBase
	{
		public var insNameSprite:GBase;
		public var needMobilityText:GText;
		public var startSprite1:GBase;
		public var startSprite2:GBase;
		public var startSprite3:GBase;
		
		public var combatBtn:GButton;
		public var exploreBtn:GButton;
		public var raiderBtn:GButton;
		public var returnBtn:GButton;
		public var cardBtn:GButton;
		public var shopBtn:GButton;
		
		public var simpleInsItem:InsConditionItemPanel;
		public var normalInsItem:InsConditionItemPanel;
		public var hardInsItem:InsConditionItemPanel;
		
		public var mapID:uint;
		public var insIdx:uint;
		private var insIDList:Array;
		private var insDataList:Array;
		private var _starLv:uint;
		private var _nameText:Bitmap;
		
		private static var _instance:InsCombatPanel;
		public static function get instance():InsCombatPanel
		{
			return _instance ? _instance : (_instance = new InsCombatPanel());
		}
		
		public function InsCombatPanel()
		{
			super(InsCombatPanelSkin);
			setup();
		}
		
		private function setup():void
		{
			_nameText = new Bitmap();
			insNameSprite.addChild(_nameText);
			addEvents();
		}
		
		public function setInsData(insIDList:Array, insDataList:Array):void
		{
			this.insIDList = insIDList;
			this.insDataList = insDataList;
			
			this.invalidateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			_starLv = GlobalData.mainPlayerInfo.calcInsStarLv(this.insIDList);
			simpleInsItem.setFinish(_starLv > 0);
			normalInsItem.setFinish(_starLv > 1);
			hardInsItem.setFinish(_starLv > 2);
			// 三星的话，战斗按钮不显示 ADD TO
			
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemNamePath(mapID, insIdx), nameBitmapComplete);
		}
		
		private function nameBitmapComplete(bitmapData:BitmapData):void
		{
			_nameText.bitmapData = bitmapData;
			_nameText.x = -_nameText.width * 0.5;
			_nameText.y = -_nameText.height * 0.5;
		}
		
		private function addEvents():void
		{
			combatBtn.addEventListener(MouseEvent.CLICK, onCombatBtnClick);
			returnBtn.addEventListener(MouseEvent.CLICK, onReturnBtnClick);
			cardBtn.addEventListener(MouseEvent.CLICK, onCardBtnClick);
			
			simpleInsItem.addEventListener(MouseEvent.CLICK, onSimpleInsClick);
			normalInsItem.addEventListener(MouseEvent.CLICK, onNormalInsClick);
			hardInsItem.addEventListener(MouseEvent.CLICK, onHardInsClick);
		}
		
		private function removeEvents():void
		{
			combatBtn.removeEventListener(MouseEvent.CLICK, onCombatBtnClick);
			returnBtn.removeEventListener(MouseEvent.CLICK, onReturnBtnClick);
			cardBtn.removeEventListener(MouseEvent.CLICK, onCardBtnClick);
			
			simpleInsItem.removeEventListener(MouseEvent.CLICK, onSimpleInsClick);
			normalInsItem.removeEventListener(MouseEvent.CLICK, onNormalInsClick);
			hardInsItem.removeEventListener(MouseEvent.CLICK, onHardInsClick);
		}
		
		private function onCardBtnClick(e:MouseEvent):void
		{
			if (parent)
				parent.removeChild(this);
			
			if (!GlobalData.roleCardPanel)
				GlobalData.roleCardPanel = new RoleCardPanel();
			
			GlobalAPI.layerManager.setModuleContent(GlobalData.roleCardPanel);
		}
		
		private function onSimpleInsClick(e:MouseEvent):void
		{
			_starLv = GlobalData.mainPlayerInfo.calcInsStarLv(this.insIDList);
			if (_starLv != 0)
				return;
			
			gotoCombatByIndex(0);
		}
		
		private function onNormalInsClick(e:MouseEvent):void
		{
			_starLv = GlobalData.mainPlayerInfo.calcInsStarLv(this.insIDList);
			if (_starLv != 1)
				return;
			
			gotoCombatByIndex(1);
		}
		
		private function onHardInsClick(e:MouseEvent):void
		{
			_starLv = GlobalData.mainPlayerInfo.calcInsStarLv(this.insIDList);
			if (_starLv != 2)
				return;
			
			gotoCombatByIndex(2);
		}
		
		private function onCombatBtnClick(e:MouseEvent):void
		{
			_starLv = GlobalData.mainPlayerInfo.calcInsStarLv(this.insIDList);
			if (_starLv >= 3)
				return;
			
			gotoCombatByIndex(_starLv);
		}
		
		private function gotoCombatByIndex(idx:int):void
		{
			var insID:uint = insIDList ? uint(insIDList[idx]) : 0;
			if (insID <= 0)
				return;
			
			var hasFinish:Boolean = GlobalData.mainPlayerInfo.insFinishList.indexOf(insID) != -1;
			if (hasFinish)
				return;
			
			var insData:InsMapData = InsMapDataList.getInsMapData(insID);
			gotoCombat(insData, insID);
		}
		
		private var _currCombatInsID:uint;
		private function gotoCombat(actData:InsMapData, insID:uint):void
		{
			if (!actData)
				return;

			if (GlobalData.mainPlayerInfo.totalBody < actData.needMobility)
			{
				// 提示体力不足
				
				return;
			}
			
			GlobalData.mainPlayerInfo.totalBody -= actData.needMobility;
			_currCombatInsID = insID;
			GlobalData.forTestCombat(actData, onCombatComplete);
		}
		
		private function onCombatComplete(resultData:CombatResultData):void
		{
			if (!resultData)
				return;
			
			if (resultData.result != 0)
				GlobalData.mainPlayerInfo.flagInsIDFinish(_currCombatInsID);
			
			_currCombatInsID = 0;
		}
		
		private function onReturnBtnClick(e:MouseEvent):void
		{
//			GlobalEventDispatcher.dispatch(new Event(GlobalEventDispatcher.INS_COMBAT_HIDE));
			GlobalAPI.layerManager.returnLastModule();
		}
	}
}