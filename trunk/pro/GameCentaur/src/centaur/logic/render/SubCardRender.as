package centaur.logic.render
{
	import centaur.data.GlobalAPI;
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import ghostcat.ui.controls.GBuilderBase;

	/**
	 *  卡牌的显示形态，主要分为头像，中等大小，详细大小，死亡头像等显示类型
	 *   @author wangq 2013.04.26
	 */ 
	public class SubCardRender extends GBuilderBase
	{
		protected var _cardObj:BaseCardObj;	// 卡牌数据对象
		protected var _bitmap:Bitmap;		// 卡牌的位图
		
		public function SubCardRender(cardObj:BaseCardObj, skin:* = null, replace:Boolean = true)
		{
			_cardObj = cardObj;
			super(skin, replace);
			
			setup();
		}
		
		protected function setup():void
		{
			if (!_cardObj)
				return;
			
			_bitmap = new Bitmap();
			addChildAt(_bitmap, 0);
			
			// 显示卡牌图片
			var bitmapPath:String = getBitmapPath();
			if (bitmapPath)
				GlobalAPI.loaderManager.getBitmapInstance(bitmapPath, onBitmapLoadComplete);
		}
		
		protected function getBitmapPath():String
		{
			return null;
		}
		
		protected function onBitmapLoadComplete(bitmapData:BitmapData):void
		{
			if (!_bitmap)
			{
				_bitmap = new Bitmap(bitmapData);
				addChildAt(_bitmap, 0);
			}
			else
				_bitmap.bitmapData = bitmapData;
		}
		
		override public function destory():void
		{
			if (_bitmap)
			{
				if (_bitmap.parent == this)
					removeChild(_bitmap);
				_bitmap.bitmapData = null;
				_bitmap = null;
			}
			
			_cardObj = null;
			super.destory();
		}
		
		public function handleHPChange(damage:int):void
		{
			
		}
		
		public function handleAttackChange(attack:int):void
		{
		}
		
		public function handleWaitRoundChange(round:int):void
		{
		}
	}
}