package centaur.logic.render
{
	import assetcard.CardHeadRenderSkin;
	
	import centaur.data.GlobalAPI;
	import centaur.display.control.GBitmapNumberText;
	import centaur.logic.act.BaseCardObj;
	import centaur.utils.NumberType;
	
	import flash.display.BitmapData;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GText;

	/**
	 *   卡牌头像模式显示类
	 *   @author wangq 2013.04.13
	 */ 
	public class CardHeadRender extends SubCardRender
	{
		public var attackText:GBitmapNumberText;	// 攻击力信息
		public var hpText:GBitmapNumberText;		// 血量信息
		public var waitRoundText:GBitmapNumberText;	// 如果是等待区的头像卡牌,则需要显示等待回合
		public var borderSide:GBase;
		
		private var _originWidth:Number;
		private var _originHeight:Number;
		private var _waitRound:int;
		
		public function CardHeadRender(cardObj:BaseCardObj, skin:* = null)
		{
			if (!skin)
				skin = CardHeadRenderSkin;
			super(cardObj, skin);
		}
		
		override protected function getBitmapPath():String
		{
			return GlobalAPI.pathManager.getCardHeadByID(_cardObj.cardData.templateID);
		}
		
		override protected function setup():void
		{
			_originWidth = borderSide ? borderSide.width : 120;
			_originHeight = borderSide ? borderSide.height : 120;
			
			super.setup();
			
			if (attackText)
				attackText.mouseChildren = attackText.mouseEnabled = false;
			if (hpText)
				hpText.mouseChildren = hpText.mouseEnabled = false;
			if (waitRoundText)
				waitRoundText.mouseChildren = waitRoundText.mouseEnabled = false;
			
			// 初始化战斗力，血量等信息
			if (_cardObj)
			{
				if (attackText)
					attackText.setNumber(_cardObj.cardData.attack, NumberType.SMALL_WHITE_NUMBER);
				if (hpText)
					hpText.setNumber(_cardObj.cardData.maxHP, NumberType.SMALL_WHITE_NUMBER);
				if (waitRoundText)
					waitRoundText.setNumber(_waitRound = _cardObj.cardData.waitRound, NumberType.SMALL_WHITE_NUMBER);
			}
		}
		
		override protected function onBitmapLoadComplete(bitmapData:BitmapData):void
		{
			if (!bitmapData)
				return;
			
			_bitmap.x = (_originWidth - bitmapData.width) * 0.5;
			_bitmap.y = (_originHeight - bitmapData.height) * 0.5;
			
			super.onBitmapLoadComplete(bitmapData);
		}
		
		override public function handleWaitRoundChange(round:int):void
		{
			_waitRound -= round;
			if (waitRoundText)
				waitRoundText.setNumber(_waitRound, NumberType.SMALL_WHITE_NUMBER);
		}
	}
}