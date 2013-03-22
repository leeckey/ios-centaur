package ghostcat.operation
{
    import ghostcat.events.OperationEvent;
    import ghostcat.util.Util;

    /**
     * 同时处理多个操作，用于不需要排队的情况
     * 
     * @author flashyiyi
     * 
     */    
    public class GroupOper extends Oper
    {
        public var children:Array;
        /**
         * 完成数量
         */
        public var finishCount:int = 0;
        
        public function GroupOper(children:Array=null)
        {
            super();
            
            if (!children)
                children = [];
            
            this.children = children;
        }
        
        /**
         * 推入队列
         * 
         */            
        public function commitChild(obj:Oper):void
        {
            children.push(obj);
        }
        
        /**
         * 移出队列
         * 
         */
        public function haltChild(obj:Oper):void
        {
            Util.remove(children,obj);
            if (children.length==0)
                result();
        }
        
        public override function execute():void
        {
            super.execute();
            
            finishCount = 0;
            
            var length:int = children.length;
            for (var i:int = 0; i < length; i++)
            {
                var oper:Oper = children[i] as Oper;
                oper.addEventListener(OperationEvent.OPERATION_COMPLETE,childCompleteHandler);
                oper.addEventListener(OperationEvent.OPERATION_ERROR,childErrorHandler);
                oper.execute();
            }
        }
        
        private function childCompleteHandler(event:OperationEvent):void
        {
            endOperation(event.currentTarget as Oper);
        }
        
        private function childErrorHandler(event:OperationEvent):void
        {
            endOperation(event.currentTarget as Oper);
        }
        
        private function endOperation(oper:Oper):void
        {
            oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,childCompleteHandler);
            oper.removeEventListener(OperationEvent.OPERATION_ERROR,childErrorHandler);
            finishCount++;
            
            if (children.length == finishCount)
                result();
        }

    }
}