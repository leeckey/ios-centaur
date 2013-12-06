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
			
			GlobalAPI.loaderManager.getBitmapInstance(GlobalAPI.pathManager.getMapItemPath(mapID, insIdx), onItemBackComplete);
		}
		
		private function onItemBackComplete(data:BitmapData):void
		{
			_back.bitmapData = data;
		}
	}
}