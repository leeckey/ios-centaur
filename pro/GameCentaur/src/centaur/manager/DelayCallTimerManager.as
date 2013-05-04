package centaur.manager
{
    import centaur.interfaces.ITimerManager;
    
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

    /**
    *  延迟定时器统一管理，确保使用简单方便，定时结束时会自动清理
    *  @author wangq 2012.06.12
    */ 
    public final class DelayCallTimerManager implements ITimerManager
    {
        /**
        *  定时器对象池
        */ 
        private var _timerPool:Vector.<Timer> = new Vector.<Timer>();
        
		/** 定时器的字典对象,快速查找用 */
		private var _timerDictionary:Dictionary = new Dictionary();
		
        /**
         *  延迟调用映射表
         */
        private var _delayCallMap:Dictionary = new Dictionary(true);
        
        private function getAvailableTimer():Timer
        {
            var timer:Timer = _timerPool.pop();
			if (timer)
				delete _timerDictionary[timer];
            if (!timer)
                timer = new Timer(0);
            
            if (timer.running)
                throw Error("got available timer is running");
            
            timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            timer.stop();
            
            return timer;
        }
        
        /**
         *  开始一个延迟定时操作
         */
        public function startDelayCall(delay:Number, delayCall:Function, repeat:int = int.MAX_VALUE, parameters:Array = null):Timer
        {
            if (delay < 0)
                delay = 0;
            
            var timer:Timer = getAvailableTimer();
            _delayCallMap[timer] = parameters ? {handler : delayCall, param : parameters} : delayCall;
            timer.delay = delay;
            timer.repeatCount = repeat;
            timer.reset();
            timer.start();
            
            return timer;
        }
        
        /**
         *  停止定时操作
         */
        public function stopDelayCall(timer:Timer, handler:Function):void
        {
            if (!timer || (handler == null))
                return;
            
            var params:Object = _delayCallMap[timer];
            if (!params)
                return;
            
            if (!(params == handler || 
                (params.hasOwnProperty("handler") && params.handler == handler)))
                return;
            
            _delayCallMap[timer] = null;
            pushToPool(timer);
        }
        
        /**
         *  将定时器推到对象池中
         */ 
        private function pushToPool(timer:Timer):void
        {
            if (!timer)
                return;
            
            timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            timer.stop();
            
            if (timer.running)
				throw Error("push a timer which is running");
            
            if (!_timerDictionary[timer])
			{
				_timerPool.push(timer);
				_timerDictionary[timer] = true;
			}
        }
        
        /**
         *  定时Timer处理函数
         */
        private function onTimerHandler(e:TimerEvent):void
        {
            var timer:Timer = e.currentTarget as Timer;
            if (!timer)
                return;
            
            var handler:* = _delayCallMap[timer];
            if (handler is Function)
                (handler as Function).apply();
            else if (handler is Object)
            {
                var call:Function = (handler as Object).handler;
                var param:Array = (handler as Object).param;
                if (call != null)
                    call.apply(null, param);
            }
        }
        
        /**
         *  定时完成处理函数
         */
        private function onTimerComplete(e:TimerEvent):void
        {
            var timer:Timer = e.currentTarget as Timer;
            if (!timer)
                return;
            
            _delayCallMap[timer] = null;
            pushToPool(timer);
        }
    }
}