package centaur.display.control
{
	import flash.display.DisplayObject;

	/**
	 *   卡牌显示滚动面板
	 */ 
	public final class ScaledScrollPanel extends MobileScrollPanel
	{
		public var itemList:Array;
		public var itemWidth:int;
		public var itemHeight:int;
		
		public function ScaledScrollPanel()
		{
			super();
		}
		
		override protected function setup():void
		{
			super.setup();
		}
		
		override public function set scrollH(v:int):void
		{
			super.scrollH = v;
			onUpdateScrollH();
		}
		
		override public function set scrollV(v:int):void
		{
			super.scrollV = v;
			onUpdateScrollV();
		}
		
		private function onUpdateScrollH():void
		{
			if (!itemList || itemWidth <= 0)
				return;
			
			var posIdx:Number = Math.abs(content.x) / itemWidth;
			var preIdx:int = int(posIdx);
			var nextIdx:int = preIdx + 1;
			var part:Number = posIdx - preIdx;
			
			var item:DisplayObject = itemList[preIdx];
//			item.scaleX = item.scaleY = 1 + (1 - part) * 0.5;
			
			
			
		}
		
		private function onUpdateScrollV():void
		{
		}
	}
}