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
		private var selectBack:Bitmap;
		private var disableBack:Bitmap;
		private var lockBitmap:Bitmap;
		private var numSpriteContainer:Sprite;
		private var numSprite:Sprite;
		
		private var _mapEnable:Boolean = true;
		private var _selected:Boolean = false;
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
			selectBack = new Bitmap();
			addChild(selectBack);
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
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemBack3Path(), back3Complete);
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemLockPath(), lockBitmapComplete);
		}
		
		public function setEnable(enable:Boolean):void
		{
			_mapEnable = enable;
			disableBack.visible = !enable;
			back.visible = enable && !_selected;
			numSpriteContainer.visible = true;
			lockBitmap.visible = !enable;
			selectBack.visible = enable && _selected;
		}
		
		public function getEnable():Boolean
		{
			return _mapEnable;
		}
		
		public function setSelected(val:Boolean):void
		{
			if (_selected == val)
				return;
			
			_selected = val;
			selectBack.visible = _mapEnable && _selected;
			back.visible = _mapEnable && !_selected;
			this.y += _selected ? 20 : -20;
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
		
		private function back3Complete(data:BitmapData):void
		{
			selectBack.bitmapData = data;
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
				lockBitmap.x = back.width * 0.75 - lockBitmap.width * 0.5;
				lockBitmap.y = back.height * 0.6 - lockBitmap.height * 0.5;
			}
			if (disableBack)
			{
				disableBack.x = (back.width - disableBack.width) * 0.5;
				disableBack.y = (back.height - disableBack.height) * 0.5;
			}
			if (selectBack)
			{
				selectBack.x = (back.width - selectBack.width) * 0.5;
				selectBack.y = (back.height - selectBack.height) * 0.5;
			}
		}
	}
}