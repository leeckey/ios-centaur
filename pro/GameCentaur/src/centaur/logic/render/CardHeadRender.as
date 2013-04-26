package centaur.logic.render
{
	import card.CardHeadRenderSkin;
	
	import centaur.data.GlobalAPI;
	import centaur.logic.act.BaseCardObj;
	
	import ghostcat.ui.controls.GText;

	/**
	 *   卡牌头像模式显示类
	 *   @author wangq 2013.04.13
	 */ 
	public class CardHeadRender extends SubCardRender
	{
		public var attackText:GText;	// 攻击力信息
		public var hpText:GText;		// 血量信息
		public var waitRoundText:GText;	// 如果是等待区的头像卡牌,则需要显示等待回合
		
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
			super.setup();
			
			if (attackText)
				attackText.mouseChildren = attackText.mouseEnabled = false;
			if (hpText)
				hpText.mouseChildren = hpText.mouseEnabled = false;
			
			// 初始化战斗力，血量等信息
			if (_cardObj)
			{
				if (attackText)
					attackText.text = String(_cardObj.cardData.attack);
				if (hpText)
					hpText.text = String(_cardObj.cardData.maxHP);
			}
		}
	}
}