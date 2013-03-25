package centaur.manager
{
	import centaur.interfaces.ITick;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 *   帧频Tick管理器
	 */ 
	public final class TickManager
	{
		private var _tickList:Vector.<ITick>;
		private var _lastTime:int;
		
		public function TickManager(stage:Stage)
		{
			_tickList = new Vector.<ITick>();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_lastTime = getTimer();
		}
		
		public function addTick(tick:ITick):void
		{
			if (!tick)
				return;
			
			if (_tickList.indexOf(tick) == -1)
				_tickList.push(tick);
		}
		
		public function removeTick(tick:ITick):void
		{
			if (!tick)
				return;
			
			var idx:int;
			if ((idx = _tickList.indexOf(tick)) > -1)
				_tickList.splice(idx, 1);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var currTime:int = getTimer();
			var delta:int = currTime - _lastTime;
			_lastTime = currTime;
			
			onTick(delta);
		}
		
		private function onTick(delta:int):void
		{
			var len:int = _tickList.length;
			for (var i:int = len - 1; i >= 0; --i)
			{
				var tick:ITick = _tickList[i];
				if (tick)
					tick.update(1, delta);
			}
		}
		
	}
}