package centaur.display.ui.card
{
	import centaur.data.GameDefines;
	import centaur.data.GlobalData;
	import centaur.data.card.CardData;
	import centaur.data.card.CardTemplateData;
	import centaur.data.card.CardTemplateDataList;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillDataList;
	import centaur.display.control.GImageProgress;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.render.CardDetailRender;
	import centaur.logic.render.CardMediumRender;
	import centaur.logic.skills.BaseSkill;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;

	public final class CardDetailPanel extends GBuilderBase
	{
		public var backgroundImg:GBase;
		public var cardPanel:GBase;
		public var okBtn:GButton;
		public var configBtn:GButton;
		public var discriptionText:GText;
		public var nameText:GText;
		public var countryText:GText;
		public var lvText:GText;
		public var EXPProgress:GImageProgress;
		
		private var _detailRender:CardDetailRender;
		
		private var _cardData:BaseCardObj;
		
		public function CardDetailPanel()
		{
			super(cardDetailPanelAsset);
			
			setup();
		}
		
		public function setup():void
		{
			if (backgroundImg)
				backgroundImg.alpha = 0.8;
			
			okBtn.addEventListener(MouseEvent.CLICK, onOKClick);
			this.addEventListener(MouseEvent.CLICK, onOKClick);
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
			if (_detailRender)
				_detailRender.destory();
			_detailRender = new CardDetailRender(_cardData);
			cardPanel.addChild(_detailRender);
			
			updateDiscription();
			
			updateCardInfo();
		}
		
		private function updateCardInfo():void
		{
			if (!_cardData || !_cardData.cardData)
				return;
			
			var cardTemplateData:CardTemplateData = CardTemplateDataList.getCardData(_cardData.cardData.templateID);
			if (cardTemplateData)
				this.nameText.text = cardTemplateData.name;
			this.countryText.text = "国家：" + GameDefines.COUNTRY_STR[_cardData.cardData.country];
			this.lvText.text = "Lv：" + String(_cardData.cardData.lv);
			
			EXPProgress.setprogress(0.3);
		}
		
		private function updateDiscription():void
		{
			if (!discriptionText)
				return;
			
			var discrip:String = "";

			var skillData:BaseSkill = null;
			skillData = _cardData.getSkillByIndex(1);
			if (skillData)
			{
				discrip += skillData.skillName;
				if (skillData.skillLevel > 0)
					discrip += skillData.skillLevel.toString();
				discrip += "\n  " + skillData.getSkillDesc() + "\n";
			}
			
			skillData = _cardData.getSkillByIndex(2);
			if (skillData)
			{
				discrip += "\n";
				discrip += skillData.skillName;
				if (skillData.skillLevel > 0)
					discrip += skillData.skillLevel.toString();
				discrip += "\n  " + skillData.getSkillDesc() + "\n";
			}
			
			skillData = _cardData.getSkillByIndex(3);
			if (skillData)
			{
				discrip += "\n";
				discrip += skillData.skillName;
				if (skillData.skillLevel > 0)
					discrip += skillData.skillLevel.toString();
				discrip += "\n  " + skillData.getSkillDesc() + "\n";
			}
/*				var skillLen:int = cardTemplateData.skillList.length;
				
				for (var i:int = 0; i < skillLen; ++i)
				{
					var skillData:SkillData = SkillDataList.getSkillData(cardTemplateData.skillList[i]);
					if (!skillData)
						continue;
					
					discrip += skillData.name + "\n";
					discrip += "  " + skillData.discription + "\n";
				}*/
			
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