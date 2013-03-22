package ghostcat.util.core
{
    import flash.utils.Dictionary;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    
    import ghostcat.events.TickEvent;
    import ghostcat.util.Tick;
    import ghostcat.util.Util;
    

    /**
     * CallLater机制
     * 
     * 这是一个很重要的优化性能的方法
     * 
     * @author flashyiyi
     * 
     */
    public final class CallLater
    {
        private static var globeDirty:Dictionary = new Dictionary();
        
        private static var objectDirty:Dictionary = new Dictionary();
        
        private static function waitToCallLater(h:Handler,uniqueOn:*):void
        {
            if (_timerID)
                clearTimeout(_timerID);
            _timerID = 0;
            
            var dirty:Dictionary = uniqueOn ? objectDirty[uniqueOn] : globeDirty;
            
            if (dirty && dirty[h.handler])
            {
                h.call();
                delete dirty[h.handler];
        
                //如果对象的Dirty已清空，则删除对象字典
                if (uniqueOn && Util.isEmpty(dirty))
                    delete objectDirty[uniqueOn];
            }
        }
        
        private static function setDirty(handler:Function,uniqueOn:*):void
        {
            var dirty:Dictionary;
            if (uniqueOn)
            {
                if (!objectDirty[uniqueOn])
                    objectDirty[uniqueOn] = new Dictionary();
                dirty = objectDirty[uniqueOn];
            }
            else
                dirty = globeDirty;
            
            dirty[handler] = true;
        }
        
        /**
         * 延迟调用
         * 
         * @param handler    函数
         * @param para    函数参数
         * @param unique    是否限定函数只执行一次，
         * 不同参数的函数被认为是一个函数，不同对象的同名方法被认为是不同的方法
         * 
         * @param uniqueOn    除了函数本身，附加的判断是否重复调用的依据
         * 
         */
        public static function callLater(handler:Function,para:Array = null,unique:Boolean = false,uniqueOn:*=null):void
        {
            var h:Handler = new Handler(handler,para);
            
            if (_timerID)
                clearTimeout(_timerID);
            _timerID = 0;
            
            if (unique)
            {
                setDirty(h.handler,uniqueOn);
                _timerID = setTimeout(waitToCallLater,0,h,uniqueOn);
            }
            else
                _timerID = setTimeout(callLaterImpl, 0, h.call);
        }
        
        private static var _timerID:int;
        private static function callLaterImpl(handler:Function):void
        {
            if (_timerID)
                clearTimeout(_timerID);
            _timerID = 0;
            
            if (handler != null)
                handler.apply();
        }
        
        /**
         * 在下一帧延迟调用（这个方法依赖于Tick，Tick暂停时将不会执行）
         * 
         * @param handler    函数
         * @param para    函数参数
         * @param unique    是否限定函数只执行一次，
         * 不同参数的函数被认为是一个函数，不同对象的同名方法被认为是不同的方法
         * 
         * @param uniqueOn    除了函数本身，附加的判断是否重复调用的依据
         * 
         */
        public static function callLaterNextFrame(handler:Function,para:Array = null,unique:Boolean = false,uniqueOn:*=null):void
        {
            var h:Handler = new Handler(handler,para);
            
            if (unique)
                setDirty(h.handler,uniqueOn);
            
            Tick.instance.addTickHandler(tickHandler);
            
            function tickHandler(event:TickEvent):void
            {
                Tick.instance.removeTickHandler(tickHandler);
                if (unique)
                    waitToCallLater(h,uniqueOn);
                else
                    h.call();
            }
        }
    }
}