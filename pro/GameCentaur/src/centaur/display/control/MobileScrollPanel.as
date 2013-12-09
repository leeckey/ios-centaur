package centaur.display.control
{
	import centaur.data.GlobalAPI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GScrollPanel;

	/**
	 *   移动设备使用的滚动面板
	 *   @author wangq 2013.07.17
	 */ 
	public class MobileScrollPanel extends GScrollPanel
	{
		public var enableSmooth:Boolean = false;
		private var _smoothTimer:Timer;
		
		protected var _move:Boolean = false;
		private var _hasScroll:Boolean = false;
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
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(e:MouseEvent):void
		{
			if (_hasScroll)
				e.preventDefault();
			_hasScroll = false;
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			clearSmoothTimer();
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_move = true;
			_hasScroll = false;
			_lastMoveX = e.stageX;
			_lastMoveY = e.stageY;
			_lastDeltaX = _lastDeltaY = 0;
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			_move = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			// 先处理水平方向
			if (enableSmooth && _lastDeltaX != 0)
			{
				if (_smoothTimer)
					GlobalAPI.timerManager.stopDelayCall(_smoothTimer, onSmoothUpdate);
				_smoothTimer = GlobalAPI.timerManager.startDelayCall(40, onSmoothUpdate);
			}
			else
				onSmoothComplete();
		}
		
		protected function onSmoothUpdate():void
		{
			if (Math.abs(_lastDeltaX) < 2)
			{
				clearSmoothTimer();
				_lastDeltaX = 0;
				onSmoothComplete();
				return;
			}
			
			if (wheelDirect == UIConst.HORIZONTAL && _lastDeltaX != 0)
				tweenTargetH = scrollH = Math.min(maxScrollH,Math.max(0,scrollH - _lastDeltaX * wheelSpeed));
			_lastDeltaX *= 0.9;
			dispatchEvent(new Event(Event.SCROLL));
		}
		
		protected function onSmoothComplete():void
		{
			
		}
		
		protected function clearSmoothTimer():void
		{
			if (_smoothTimer)
				GlobalAPI.timerManager.stopDelayCall(_smoothTimer, onSmoothUpdate);
			_smoothTimer = null;
		}
		
		protected var _lastDeltaX:Number = 0;
		protected var _lastDeltaY:Number = 0;
		protected function onMouseMove(e:MouseEvent):void
		{
			if (_move)
			{
				_hasScroll = true;
				var deltaX:Number = e.stageX - _lastMoveX;
				var deltaY:Number = e.stageY - _lastMoveY;
				_lastMoveX = e.stageX;
				_lastMoveY = e.stageY;
				_lastDeltaX = deltaX;
				_lastDeltaY = deltaY;
				
				if (wheelDirect == UIConst.HORIZONTAL && deltaX != 0)
					tweenTargetH = scrollH = Math.min(maxScrollH,Math.max(0,scrollH - deltaX * wheelSpeed));
				
				if (wheelDirect == UIConst.VERTICAL && deltaY != 0)
					tweenTargetV = scrollV = Math.min(maxScrollV,Math.max(0,scrollV - deltaY * wheelSpeed));
				
				dispatchEvent(new Event(Event.SCROLL));
			}
		}
		
		public function get hasScroll():Boolean
		{
			return _hasScroll;
		}
	}
}