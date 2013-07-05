package centaur.display.ui.card
{
	import centaur.data.GlobalData;
	import centaur.data.card.CardData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.render.CardMediumRender;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;

	public final class CardDetailPanel extends GBuilderBase
	{
		public var cardPanel:GBase;
		public var okBtn:GButton;
		public var configBtn:GButton;
		
		private var _mediumRender:CardMediumRender;
		
		private var _cardData:BaseCardObj;
		
		public function CardDetailPanel()
		{
			super(cardDetailPanelAsset);
			
			setup();
		}
		
		public function setup():void
		{
			okBtn.addEventListener(MouseEvent.CLICK, onOKClick);
			
		}
		
		private function onOKClick(e:Event):void
		{
			GlobalData.hideCardDetailPanel();
		}
		
		public function set cardData(value:BaseCardObj):void
		{
			if (_cardData != value)
			{
				_cardData = value;
				
				updateCardDisplay();
			}
		}
		
		private function updateCardDisplay():void
		{
			if (_mediumRender)
				_mediumRender.destory();
			_mediumRender = new CardMediumRender(_cardData);
			cardPanel.addChild(_mediumRender);
			_mediumRender.scaleX = cardPanel.width / _mediumRender.width;
			_mediumRender.scaleY = cardPanel.height / _mediumRender.height;
		}
	}
}