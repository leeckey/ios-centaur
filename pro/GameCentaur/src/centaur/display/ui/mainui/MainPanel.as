package centaur.display.ui.mainui
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.display.control.GBitmapNumberText;
	import centaur.display.control.GImageProgress;
	import centaur.display.ui.map.MapPanel;
	import centaur.display.ui.role.RoleCardPanel;
	import centaur.utils.NumberType;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;

	public final class MainPanel extends GBuilderBase
	{
		public var mapBtn:GButton;
		public var strengthBtn:GButton;
		public var socialBtn:GButton;
		public var cardBtn:GButton;
		public var shopBtn:GButton;
		public var menuBtn:GButton;
		
		public var headSprite:GBase;
		public var lvText:GBitmapNumberText;
		public var nameTxt:GText;
		public var diamondTxt:GBitmapNumberText;
		public var moneyTxt:GBitmapNumberText;
		public var addVigourBtn:GButton;
		public var bodyText:GBitmapNumberText;
		public var bodyProgress:GImageProgress;
		
		public function MainPanel()
		{
			super(mainUIAsset);
			
			this.setup();
		}
		
		private function setup():void
		{
			initInfo();
			addEvents();
		}
		
		private function initInfo():void
		{
			initHead();
			
			updateDisplay();
		}
		
		private function updateDisplay():void
		{
			lvText.setNumber(GlobalData.mainPlayerInfo.lv, NumberType.SMALL_WHITE_NUMBER);
			nameTxt.text = String(GlobalData.mainPlayerInfo.name);
			diamondTxt.setNumber(GlobalData.mainPlayerInfo.diamond, NumberType.MIDDLE_WHITE_NUMBER);
			moneyTxt.setNumber(GlobalData.mainPlayerInfo.money, NumberType.MIDDLE_WHITE_NUMBER);
			bodyText.setStrNumber(GlobalData.mainPlayerInfo.totalBody + "/" + GlobalData.mainPlayerInfo.maxBody, NumberType.MIDDLE_WHITE_NUMBER);
			var precent:Number = GlobalData.mainPlayerInfo.totalBody / GlobalData.mainPlayerInfo.maxBody;
			if (precent > 1) precent = 1;
			bodyProgress.setprogress(precent);
		}
		
		private function initHead():void
		{
			// 初始化头像
			var headBitmap:Bitmap = new Bitmap(GlobalData.mainPlayerInfo.sex ? new HeadIconAsset1() : new HeadIconAsset2());
			headBitmap.x = (headSprite.width - headBitmap.width) * 0.5;
			headBitmap.y = (headSprite.height - headBitmap.height) * 0.5;
			
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0, 1);
			mask.graphics.drawCircle(headSprite.width * 0.5, headSprite.height * 0.5, headBitmap.width * 0.5 + 4);
			mask.graphics.endFill();
			headSprite.addChild(mask);
			headBitmap.mask = mask;
			
			headSprite.addChild(headBitmap);
		}
		
		private function addEvents():void
		{
			if (mapBtn)
				mapBtn.addEventListener(MouseEvent.CLICK, onMapBtnClick);
			if (cardBtn)
				cardBtn.addEventListener(MouseEvent.CLICK, onCardBtnClick);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.updateDisplay();
		}
		
		private function removeEvents():void
		{
			if (mapBtn)
				mapBtn.removeEventListener(MouseEvent.CLICK, onMapBtnClick);
			if (cardBtn)
				cardBtn.removeEventListener(MouseEvent.CLICK, onCardBtnClick);
		}
		
		private function onMapBtnClick(e:MouseEvent):void
		{
			if (parent)
				parent.removeChild(this);
			
			if (!GlobalData.mapPanel)
				GlobalData.mapPanel = new MapPanel();
			GlobalData.mapPanel.mapID = 1;
			GlobalAPI.layerManager.setModuleContent(GlobalData.mapPanel);
		}
		
		private function onCardBtnClick(e:MouseEvent):void
		{
			if (parent)
				parent.removeChild(this);
			
			if (!GlobalData.roleCardPanel)
				GlobalData.roleCardPanel = new RoleCardPanel();
			
			GlobalAPI.layerManager.setModuleContent(GlobalData.roleCardPanel);
		}
	}
}