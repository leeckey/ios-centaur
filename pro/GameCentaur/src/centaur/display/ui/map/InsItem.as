package centaur.display.ui.map
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.data.act.InsMapData;
	import centaur.data.act.InsMapDataList;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		private var _insMapIDList:Array;
		private var _insMapDataList:Array;
		
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
			InsCombatPanel.instance.mapID = this.mapID;
			InsCombatPanel.instance.insIdx = this.insIdx;
			InsCombatPanel.instance.setInsData(this._insMapIDList, this._insMapDataList);
			GlobalAPI.layerManager.setModuleContent(InsCombatPanel.instance);
		}
		
		override public function set data(v:*):void
		{
			if (1/*super.data != v*/)
			{
				super.data = v;
				
				if (v is String)
					_insMapIDList = (v as String).split("_");
				else if (v is Array)
					_insMapIDList = v as Array;
				else
					_insMapIDList = null;
				_insMapID = _insMapIDList ? _insMapIDList[0] : 0;
				
				// 更新副本数据列表
				updateInsMapDataList();
				_insMapData = _insMapDataList ? _insMapDataList[0] : null;
				
				// 计算当前完成星级
				updateStarLv();
				
				this.invalidateDisplayList();
			}
		}
		
		private function updateInsMapDataList():void
		{
			if (!_insMapIDList)
			{
				_insMapDataList = null;
				return;
			}
			
			_insMapDataList = [];
			var len:int = _insMapIDList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var insID:uint = uint(_insMapIDList[i]);
				_insMapDataList[i] = InsMapDataList.getInsMapData(insID);
			}
		}
		
		private function updateStarLv():void
		{
			_starLv = GlobalData.mainPlayerInfo.calcInsStarLv(_insMapIDList);
		}
		
		public function get starLv():uint
		{
			return _starLv;
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
			updateStarLvDisplay();
			
//			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemPath(mapID, insIdx), onItemBackComplete);
		}
		
		private function updateStarLvDisplay():void
		{
			if (!_starItemList) _starItemList = [];
			var totalWidth:Number;
			for (var i:int = 0; i < _starLv; ++i)
			{
				var item:GBase = _starItemList[i];
				if (!item)
				{
					item = _starItemList[i] = new GBase(InsStarSkin);
					InsMapStarLv.addChild(item);
				}
				
				totalWidth = _starLv * item.width;
				var segWidth:Number = totalWidth / _starLv;
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