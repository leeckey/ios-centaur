package centaur.display.ui.map
{
	import centaur.data.GlobalAPI;
	import centaur.utils.NumberCache;
	import centaur.utils.NumberType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import ghostcat.ui.controls.GBuilderBase;

	/**
	 *   地图Item选项，选择地图
	 */ 
	public final class MapItem extends GBuilderBase
	{
		private var back:Bitmap;
		private var disableBack:Bitmap;
		private var lockBitmap:Bitmap;
		private var numSpriteContainer:Sprite;
		private var numSprite:Sprite;
		
		private var _mapEnable:Boolean = true;
		private var _num:uint;
		
		public function MapItem()
		{
			super();
			setup();
		}
		
		private function setup():void
		{
			disableBack = new Bitmap();
			addChild(disableBack);
			back = new Bitmap();
			addChild(back);
			numSpriteContainer = new Sprite();
			addChild(numSpriteContainer);
			lockBitmap = new Bitmap();
			lockBitmap.visible = false;
			addChild(lockBitmap);
			
			setEnable(true);
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemBackPath(), backComplete);
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemBack2Path(), back2Complete);
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemLockPath(), lockBitmapComplete);
		}
		
		public function setEnable(enable:Boolean):void
		{
			_mapEnable = enable;
			disableBack.visible = !enable;
			back.visible = enable;
			numSpriteContainer.visible = enable;
			lockBitmap.visible = !enable;
		}
		
		public function getEnable():Boolean
		{
			return _mapEnable;
		}
		
		override public function set data(v:*):void
		{
			if (super.data != v)
			{
				super.data = v;
				_num = v;
				
				this.invalidateDisplayList();
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (numSprite)
			{
				if (numSprite.parent)
					numSprite.parent.removeChild(numSprite);
				numSprite = null;
			}
			numSprite = NumberCache.getNumber(_num.toString(), NumberType.MIDDLE_WHITE_NUMBER);
			numSpriteContainer.addChild(numSprite);
			layout();
		}
		
		private function backComplete(data:BitmapData):void
		{
			back.bitmapData = data;
			layout();
		}
		
		private function back2Complete(data:BitmapData):void
		{
			disableBack.bitmapData = data;
			layout();
		}
		
		private function lockBitmapComplete(data:BitmapData):void
		{
			lockBitmap.bitmapData = data;
			layout();
		}
		
		private function layout():void
		{
			if (numSprite)
			{
				numSprite.x = (back.width - numSprite.width) * 0.5;
				numSprite.y = (back.height - numSprite.height) * 0.5;
			}
			if (lockBitmap)
			{
				lockBitmap.x = (back.width - lockBitmap.width) * 0.5;
				lockBitmap.y = (back.height - lockBitmap.height) * 0.5;
			}
			if (disableBack)
			{
				disableBack.x = (back.width - disableBack.width) * 0.5;
				disableBack.y = (back.height - disableBack.height) * 0.5;
			}
		}
	}
}