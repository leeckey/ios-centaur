package centaur.display.control
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import ghostcat.ui.UIConst;
	
	import gs.TweenLite;

	/**
	 *   卡牌显示滚动面板
	 */ 
	public final class ScaledScrollPanel extends MobileScrollPanel
	{
		public var scaleMin:Number = 1.0;
		public var scaleMax:Number = 2.0;
		
		private var _itemList:Array;
		private var _itemWidth:int;
		private var _itemHeight:int;
		
		public function ScaledScrollPanel()
		{
			super();
		}
		
		override protected function setup():void
		{
			super.setup();
		}
		
		public function setupContent(itemList:Array, itemWidth:int, itemHeight):void
		{
			_itemList = itemList;
			_itemWidth = itemWidth;
			_itemHeight = itemHeight;
			
			updateItemContent();
		}
		
		override public function get maxScrollH():int
		{
			var len:int = _itemList ? _itemList.length : 0;
			if (len <= 1)
				return 0;
			
			return (len - 1) * _itemWidth;
		}
		
		override protected function onMouseUp(e:MouseEvent):void
		{
			super.onMouseUp(e);
			
			if (this.wheelDirect == UIConst.HORIZONTAL)
			{
				var posIdx:Number = Math.abs(content.x) / _itemWidth;
				var preIdx:int = int(posIdx);
				var part:Number = posIdx - preIdx;
				var tweenPosX:Number = (part < 0.5) ? (_itemWidth * preIdx) : (_itemWidth * (preIdx + 1));
				TweenLite.to(this, 0.3, {scrollH : tweenPosX});
			}
			else
			{
				
			}
		}
		
		override public function set scrollH(v:int):void
		{
			super.scrollH = v;
			updateItemContent();
		}
		
		override public function set scrollV(v:int):void
		{
			super.scrollV = v;
			updateItemContent();
		}
		
		private function updateItemContent():void
		{
			if (this.wheelDirect == UIConst.HORIZONTAL)
				onUpdateScrollH();
			else
				onUpdateScrollV();
		}
		
		private function onUpdateScrollH():void
		{
			if (!_itemList || _itemWidth <= 0)
				return;
			
			var posIdx:Number = Math.abs(content.x) / _itemWidth;
			var preIdx:int = int(posIdx);
			var nextIdx:int = preIdx + 1;
			var part:Number = posIdx - preIdx;
			
			var posX:Number = 0;
			var len:int = _itemList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var item:DisplayObject = _itemList[i];
				if (!item)
					continue;
				
				if (i > nextIdx + 1 && item.parent == this.content)	// 后面的不需要更新
					continue;
				
				var scale:Number = 1;
				if (preIdx == i)
					scale = scaleMin + (1 - part) * (scaleMax - scaleMin);
				else if (nextIdx == i)
					scale = scaleMin + part * (scaleMax - scaleMin);
				
				item.scaleX = item.scaleY = scale;
				item.x = posX;
				item.y = (_itemHeight - _itemHeight * scale) * 0.5;
				posX += item.scaleX * _itemWidth;
				
				// 确保Item添加显示
				if (item.parent != this.content)
					(content as DisplayObjectContainer).addChild(item);
			}
		}
		
		private function onUpdateScrollV():void
		{
		}
	}
}