package centaur.display.ui.map
{
	import centaur.data.GlobalAPI;
	import centaur.data.map.MapData;
	import centaur.data.map.MapDataList;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.util.display.DisplayUtil;

	/**
	 *   副本推图面板
	 */ 
	public final class MapPanel extends GBase
	{
		private var backUI:Sprite;		// 背景地图层
		private var itemUI:Sprite;		// 副本Item层
		
		private var _mapID:uint;		// 地图ID
		private var _itemList:Array;	// Item列表
		
		public function MapPanel()
		{
			super();
			
			setup();
		}
		
		protected function setup():void
		{
			backUI = new Sprite();
			backUI.mouseChildren = backUI.mouseEnabled = false;
			this.addChild(backUI);
			
			itemUI = new Sprite();
			itemUI.mouseEnabled = false;
			this.addChild(itemUI);
		
			_itemList = [];
		}
		
		public function set mapID(value:uint):void
		{
			if (_mapID != value)
			{
				_mapID = value;
				
				updateBackground();
				updateMapItems();
			}
		}
		
		private function updateBackground():void
		{
			DisplayUtil.removeAllChildren(backUI);
			if (_mapID > 0)
				GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapBackgroundPath(_mapID), onBackLoadComplete);
		}
		
		private function onBackLoadComplete(bitmapData:BitmapData):void
		{
			////----wangq 地图显示资源不匹配，先放大显示
			var bitmap:Bitmap = new Bitmap(bitmapData);
			bitmap.x = bitmap.y = -100;
			bitmap.scaleX = bitmap.scaleY = 3;
			backUI.addChild(bitmap);
		}
		
		private function updateMapItems():void
		{
			var mapInfo:MapData = MapDataList.getMapData(_mapID);
			var insMapList:Array = mapInfo.insMapList;
			var posList:Array = mapInfo.insPosList;
			
			var len:int = insMapList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var itemData:* = insMapList[i];
				var itemPos:Point = posList[i];
				var item:InsItem = _itemList[i];
				if (!item)
				{
					item = new InsItem();
					itemUI.addChild(item);
				}
				
				item.data = itemData;
				item.mapID = _mapID;
				item.insIdx = i + 1;
				item.x = itemPos.x;
				item.y = itemPos.y;
			}
			
			var itemUILen:int = _itemList.length;
			for (i = len; i < itemUILen; ++i)
			{
				item = _itemList[i];
				if (item)
					item.destory();
			}
			_itemList.length = len;
		}
		
	}
}