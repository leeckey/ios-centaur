package centaur.display.ui.map
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.map.MapData;
	import centaur.data.map.MapDataList;
	import centaur.display.control.MobileScrollPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.controls.GButton;
	import ghostcat.util.display.DisplayUtil;

	/**
	 *   副本推图面板
	 */ 
	public final class MapPanel extends GBase
	{
		public static const MAP_COUNT:uint = 10;
		
		private var backUI:Sprite;		// 背景地图层
		private var _backBitmap:Bitmap;	// 地图位图
		private var itemUI:Sprite;		// 副本Item层
		private var insListPanel:MobileScrollPanel;	// 地图列表
		private var mapItemList:Array;
		
		private var _mapID:uint;		// 地图ID
		private var _itemList:Array;	// Item列表
		private var _returnBtn:GButton;
		
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
		
			insListPanel = new MobileScrollPanel();
			this.addChild(insListPanel);
			
			// returnBtn
			_returnBtn = new GButton(commonReturnBtnSkin);
			_returnBtn.addEventListener(MouseEvent.CLICK, onReturnBtnClick);
			_returnBtn.x = 820;
			_returnBtn.y = 510;
			this.addChild(_returnBtn);
			
			mapItemList = [];
			for (var i:int = 0; i < MAP_COUNT; ++i)
			{
				var item:MapItem = new MapItem();
				item.addEventListener(MouseEvent.CLICK, onMapItemClick);
				item.data = i + 1;
				item.x = i * (180);
				item.setEnable(i < GlobalData.mainPlayerInfo.mapEnableCount);
				(insListPanel.content as Sprite).addChild(item);
				mapItemList.push(item);
			}
			insListPanel.wheelDirect = UIConst.HORIZONTAL;
			insListPanel.wheelSpeed = 1;
			insListPanel.scrollRect = new Rectangle(0, 0, 900, 100);
			insListPanel.x = (960 - 180 * 5) * 0.5;
			insListPanel.enableSmooth = true;
			
			_itemList = [];
		}
		
		private function onMapItemClick(e:MouseEvent):void
		{
			if (insListPanel && insListPanel.hasScroll)
				return;
			
			var item:MapItem = e.currentTarget as MapItem;
			if (item && item.getEnable())
				this.mapID = item.data;
		}
		
		private function onReturnBtnClick(e:MouseEvent):void
		{
			GlobalAPI.layerManager.returnLastModule();
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
			if (!_backBitmap)
				_backBitmap = new Bitmap(bitmapData);
			else
				_backBitmap.bitmapData = bitmapData;
			if (_backBitmap.parent != backUI)
				backUI.addChild(_backBitmap);
		}
		
		private function updateMapItems():void
		{
			var mapInfo:MapData = MapDataList.getMapData(_mapID);
			if (!mapInfo)
				return;
			
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
					item = _itemList[i] = new InsItem();
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