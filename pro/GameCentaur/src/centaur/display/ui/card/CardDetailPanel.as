package centaur.display.ui.card
{
	import centaur.data.GlobalData;
	import centaur.data.card.CardData;
	import centaur.data.card.CardTemplateData;
	import centaur.data.card.CardTemplateDataList;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillDataList;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.render.CardMediumRender;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;

	public final class CardDetailPanel extends GBuilderBase
	{
		public var cardPanel:GBase;
		public var okBtn:GButton;
		public var configBtn:GButton;
		public var discriptionText:GText;
		
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
			
			updateDiscription();
		}
		
		private function updateDiscription():void
		{
			if (!discriptionText)
				return;
			
			var discrip:String = "";
			var cardTemplateData:CardTemplateData = CardTemplateDataList.getCardData(_cardData.cardData.templateID);
			if (cardTemplateData)
			{
				var skillLen:int = cardTemplateData.skillList.length;
				
				for (var i:int = 0; i < skillLen; ++i)
				{
					var skillData:SkillData = SkillDataList.getSkillData(cardTemplateData.skillList[i]);
					if (!skillData)
						continue;
					
					discrip += skillData.name + "\n";
					discrip += "  " + skillData.discription + "\n";
				}
			}
			
			discriptionText.textField.multiline = true;
			discriptionText.textField.wordWrap = true;
			if (discriptionText)
			{
				discriptionText.text = discrip;
				discriptionText.height = discriptionText.textField.textHeight + 4;
			}
		}
	}
}