package centaur.display.ui.map
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.GlobalEventDispatcher;
	import centaur.data.act.InsMapData;
	import centaur.data.act.InsMapDataList;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GText;

	/**
	 *   副本Item，包含副本信息，点击可以进入战斗
	 */ 
	public final class InsItem extends GBuilderBase
	{
		public var insMapNameText:GText;
		public var insMapIdxText:GText;
		public var InsMapStarLv:GBase;
		private var _back:Bitmap;
		
		public var mapID:uint;
		public var insIdx:uint;
		private var _insMapID:uint;
		private var _insMapData:InsMapData;
		private var _starLv:int = 0;
		private var _starItemList:Array;
		
		public function InsItem()
		{
			super(insMapItemSkin);
			
			setup();
		}
		
		override public function destory():void
		{
			this.removeEventListener(MouseEvent.CLICK, onMouseClick);
			super.destory();
		}
		
		private function setup():void
		{
			_back = new Bitmap();
			addChildAt(_back, 0);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			InsCombatPanel.instance.data = _insMapID;
			InsCombatPanel.instance.mapID = this.mapID;
			InsCombatPanel.instance.insIdx = this.insIdx;
			GlobalAPI.layerManager.setModuleContent(InsCombatPanel.instance);
		}
		
		override public function set data(v:*):void
		{
			if (super.data != v)
			{
				super.data = v;
				
				_insMapID = v;
				_insMapData = InsMapDataList.getInsMapData(_insMapID);
				
				this.invalidateDisplayList()
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			updateSelf();
		}
		
		private function updateSelf():void
		{
			insMapNameText.text = _insMapData ? _insMapData.name : "";
			insMapIdxText.text = _insMapData ? (mapID + "_" + insIdx) : "";
			updateStarLv();
			
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemPath(mapID, insIdx), onItemBackComplete);
		}
		
		private function updateStarLv():void
		{
			if (!_starItemList) _starItemList = [];
			var starLvList:Array = GlobalData.mainPlayerInfo.insStarLvList;
			var starLv:int = starLvList ? int(starLvList[_insMapID]) : 0;
			var totalWidth:Number;
			for (var i:int = 0; i < starLv; ++i)
			{
				var item:GBase = _starItemList[i];
				if (!item)
				{
					item = _starItemList[i] = new GBase(InsStarSkin);
					InsMapStarLv.addChild(item);
				}
				
				totalWidth = starLv * item.width;
				var segWidth:Number = totalWidth / starLv;
				var offset:Number = (segWidth - item.width) * 0.5;
				item.x = segWidth * i + offset - totalWidth * 0.5;
				item.y = -item.height * 0.5;
			}
			
			// 清楚掉多余
			var endIdx:int = i;
			var len:int = _starItemList.length;
			for (i = endIdx; i < len; ++i)
			{
				var disposeItem:GBase = _starItemList[i];
				if (disposeItem && disposeItem.parent)
					disposeItem.parent.removeChild(disposeItem);
			}
			_starItemList.length = endIdx;
		}
		
		private function onItemBackComplete(data:BitmapData):void
		{
			_back.bitmapData = data;
		}
	}
}