package centaur.logic.render
{
	import assetcard.cardViewRenderSkin;
	
	import centaur.data.GlobalAPI;
	import centaur.logic.act.BaseCardObj;
	import centaur.manager.EmbedAssetManager;
	
	import flash.display.Bitmap;

	public final class CardViewRender extends CardDetailRender
	{
		public function CardViewRender(cardObj:BaseCardObj)
		{
			super(cardObj, cardViewRenderSkin);
			_baseScale = 0.6;
		}
		
		override protected function getBitmapPath():String
		{
			return GlobalAPI.pathManager.getCardViewBodyByID(_cardObj.cardData.templateID);
		}
		
		override protected function initSetup():void
		{
			// 优先添加卡牌种族背景,先随机测试，到时读取配置表
			_raceBitmap = new Bitmap(GlobalAPI.loaderManager.getBitmapByClass(EmbedAssetManager.getCardViewRace(_cardObj.cardData.country)));
			addChildAt(_raceBitmap, 0);
			
			_width = _raceBitmap.width;
			_height = _raceBitmap.height;
			if (_width <= 10 || _height <= 10)
			{
				_width = 234;
				_height = 334;
			}
		}
	}
}