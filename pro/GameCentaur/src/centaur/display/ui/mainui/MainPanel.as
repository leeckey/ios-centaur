package centaur.display.ui.mainui
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.display.ui.map.MapPanel;
	
	import flash.events.MouseEvent;
	
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;

	public final class MainPanel extends GBuilderBase
	{
		public var mapBtn:GButton;
		public var strengthBtn:GButton;
		public var socialBtn:GButton;
		public var cardBtn:GButton;
		public var shopBtn:GButton;
		public var menuBtn:GButton;
		
		public function MainPanel()
		{
			super(mainUIAsset);
			
			this.setup();
		}
		
		private function setup():void
		{
			addEvents();
		}
		
		private function addEvents():void
		{
			if (mapBtn)
				mapBtn.addEventListener(MouseEvent.CLICK, onMapBtnClick);	
		}
		
		private function removeEvents():void
		{
			if (mapBtn)
				mapBtn.removeEventListener(MouseEvent.CLICK, onMapBtnClick);
		}
		
		private function onMapBtnClick(e:MouseEvent):void
		{
			if (parent)
				parent.removeChild(this);
			
//			GlobalData.forTestCombat();
			if (!GlobalData.mapPanel)
				GlobalData.mapPanel = new MapPanel();
			GlobalData.mapPanel.mapID = 1;
			GlobalAPI.layerManager.getPopLayer().addChild(GlobalData.mapPanel);
			
		}
	}
}