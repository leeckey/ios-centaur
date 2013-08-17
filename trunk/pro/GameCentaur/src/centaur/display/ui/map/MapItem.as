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
		private var numSprite:Sprite;
		
		private var _num:uint;
		
		public function MapItem()
		{
			super();
			setup();
		}
		
		private function setup():void
		{
			back = new Bitmap();
			addChildAt(back, 0);
			
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemBackPath(), backComplete);
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
			numSprite = NumberCache.getNumber(_num, NumberType.MIDDLE_WHITE_NUMBER);
			addChild(numSprite);
			layout();
		}
		
		private function backComplete(data:BitmapData):void
		{
			back.bitmapData = data;
			layout();
		}
		
		private function layout():void
		{
			if (numSprite)
			{
				numSprite.x = (back.width - numSprite.width) * 0.5;
				numSprite.y = (back.height - numSprite.height) * 0.5;
			}
		}
	}
}