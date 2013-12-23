package centaur.logic.render
{
	import assetcard.cardDetailRenderSkin;
	
	import centaur.data.GlobalAPI;
	import centaur.data.card.CardTemplateData;
	import centaur.data.card.CardTemplateDataList;
	import centaur.display.control.GBitmapNumberText;
	import centaur.logic.act.BaseCardObj;
	import centaur.manager.EmbedAssetManager;
	import centaur.utils.NumberType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GText;

	/**
	 *   卡牌的详细信息显示类
	 *   @author wangq 2013.12.19
	 */ 
	public final class CardDetailRender extends SubCardRender
	{
		public var costText:GBitmapNumberText;
		public var lvText:GBitmapNumberText;
		public var attackText:GBitmapNumberText;
		public var hpText:GBitmapNumberText;
		public var nameText:GText;
		public var waitRoundText:GBitmapNumberText;
		public var starContainer:GBase;
		
		private var _starList:Array;
		private var _width:Number = 0.0;
		private var _height:Number = 0.0;
		
		private var _raceBitmap:Bitmap;				// 种族背景图片
		
		public function CardDetailRender(cardObj:BaseCardObj)
		{
			super(cardObj, cardDetailRenderSkin);
		}
		
		override public function destory():void
		{
			if (_raceBitmap && _raceBitmap.parent)
				_raceBitmap.parent.removeChild(_raceBitmap);
			_raceBitmap = null;
			
			super.destory();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function get width():Number
		{
			return _width;	
		}
		
		override protected function getBitmapPath():String
		{
			return GlobalAPI.pathManager.getCardDetailBodyByID(_cardObj.cardData.templateID);
		}
		
		override protected function onBitmapLoadComplete(bitmapData:BitmapData):void
		{
			if (!bitmapData)
				return;
			
			_bitmap.x = (this.width - bitmapData.width) * 0.5;
			_bitmap.y = (this.height - bitmapData.height) * 0.5;
			
			super.onBitmapLoadComplete(bitmapData);
		}
		
		override protected function setup():void
		{
			if (!_cardObj)
				return;
			
			// 优先添加卡牌种族背景,先随机测试，到时读取配置表
			_raceBitmap = new Bitmap(GlobalAPI.loaderManager.getBitmapByClass(EmbedAssetManager.getCardDetailRace(_cardObj.cardData.country)));
			addChildAt(_raceBitmap, 0);
			
			_width = _raceBitmap.width;
			_height = _raceBitmap.height;
			if (_width <= 10 || _height <= 10)
			{
				_width = 385;
				_height = 580;
			}
			
			super.setup();
			
			this.invalidateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (!_cardObj || !_cardObj.cardData)
				return;
			
			var templateData:CardTemplateData = CardTemplateDataList.getCardData(_cardObj.cardData.templateID);
			if (!templateData)
				return;
			
			var level:int = _cardObj.cardData.lv;
			var totalHP:int = templateData.baseHP + templateData.growUpHP * level;
			var totalAttack:int = templateData.baseACK + templateData.growUpACK * level;
			
			costText.setNumber(templateData.cost, NumberType.MIDDLE_WHITE_NUMBER);
			lvText.setNumber(level, NumberType.MIDDLE_WHITE_NUMBER);
			attackText.setNumber(totalAttack, NumberType.MIDDLE_WHITE_NUMBER);
			hpText.setNumber(totalHP, NumberType.MIDDLE_WHITE_NUMBER);
			
			nameText.text = templateData.name;
			waitRoundText.setNumber(templateData.maxWaitRound, NumberType.MIDDLE_WHITE_NUMBER);
			
			updateStarDisplay(templateData.starLv);
		}
		
		private function updateStarDisplay(starLv:uint):void
		{
			var star:GBase;
			if (!_starList) _starList = [];
			for (var i:int = 0; i < starLv; ++i)
			{
				star = _starList[i];
				if (!star)
					star = _starList[i] = new GBase(InsStarSkin);
				
				star.x = (star.width + 5) * i;
				if (star.parent != starContainer)
					starContainer.addChild(star);
			}
			
			// 清理多余星星
			for (i = starLv; i < _starList.length; ++i)
			{
				star = _starList[i];
				if (star && star.parent)
					star.parent.removeChild(star);
			}
			_starList.length = starLv;
		}
		
		
	}
}