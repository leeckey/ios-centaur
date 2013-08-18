package centaur.display.ui.map
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.GlobalEventDispatcher;
	import centaur.data.act.InsMapData;
	import centaur.data.act.InsMapDataList;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
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
		private var _nameText:Bitmap;
		private var _insMapID:uint;
		private var _insMapData:InsMapData;
		
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
		
		override public function set data(v:*):void
		{
			if (super.data != v)
			{
				super.data = v;
				
				_insMapID = v;
				_insMapData = InsMapDataList.getInsMapData(_insMapID);
			
				this.invalidateDisplayList();
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
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
		}
		
		private function removeEvents():void
		{
			combatBtn.removeEventListener(MouseEvent.CLICK, onCombatBtnClick);
			returnBtn.removeEventListener(MouseEvent.CLICK, onReturnBtnClick);
		}
		
		private function onCombatBtnClick(e:MouseEvent):void
		{
			if (_insMapData)
				GlobalData.forTestCombat(_insMapData);
		}
		
		private function onReturnBtnClick(e:MouseEvent):void
		{
			GlobalEventDispatcher.dispatch(new Event(GlobalEventDispatcher.INS_COMBAT_HIDE));
		}
	}
}