package centaur.display.control
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GScrollPanel;

	/**
	 *   移动设备使用的滚动面板
	 *   @author wangq 2013.07.17
	 */ 
	public final class MobileScrollPanel extends GScrollPanel
	{
		private var _move:Boolean = false;
		private var _lastMoveX:Number;
		private var _lastMoveY:Number;
		
		public function MobileScrollPanel()
		{
			super(Sprite);
			setup();
		}
		
		protected function setup():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_move = true;
			_lastMoveX = e.stageX;
			_lastMoveY = e.stageY;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_move = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (_move)
			{
				var deltaX:Number = e.stageX - _lastMoveX;
				var deltaY:Number = e.stageY - _lastMoveY;
				_lastMoveX = e.stageX;
				_lastMoveY = e.stageY;
				
				if (wheelDirect == UIConst.HORIZONTAL)
					tweenTargetH = scrollH = Math.min(maxScrollH,Math.max(0,scrollH - deltaX * wheelSpeed));
				
				if (wheelDirect == UIConst.VERTICAL)
					tweenTargetV = scrollV = Math.min(maxScrollV,Math.max(0,scrollV - deltaY * wheelSpeed));
				
				dispatchEvent(new Event(Event.SCROLL));
			}
			
		}
	}
}