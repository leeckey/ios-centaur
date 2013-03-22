package ghostcat.display.transfer
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    
    import ghostcat.display.GBase;
    import ghostcat.display.bitmap.GBitmap;
    import ghostcat.events.GEvent;
    import ghostcat.events.MoveEvent;
    import ghostcat.events.ResizeEvent;
    import ghostcat.util.core.UniqueCall;

    
    /**
     * 用于实时将显示对象转换为位图处理的类
     * 
     * @author flashyiyi
     * 
     */
    public class GBitmapTransfer extends GBitmap
    {
        protected var _target:DisplayObject;
        protected var renderCaller:UniqueCall = new UniqueCall(renderTarget);
        
        public function GBitmapTransfer(target:DisplayObject=null):void
        {
            super();
            
            if (target)
                this.target = target;
        }
                
        /**
         * 设置目标
         * @return 
         * 
         */
        public function get target(): DisplayObject
        {
            return _target;
        }

        public function set target(value: DisplayObject): void
        {
            removeTargetEvents();
            _target = value;
            addTargetEvents();
            
            updateTargetMove();
            createBitmapData();
            invalidateDisplayList();
        }
        
        protected override function init():void
        {
            super.init();
            updateTargetMove();
        }
                        
        /**
         * 更新目标位置
         * 
         */
        public function updateTargetMove():void
        {
            if (!stage)
                return;
            
            var rect:Rectangle = _target.getBounds(this);
            x = rect.x + this.x;
            y = rect.y + this.y;
        }
        
        /**
         * 更新目标大小
         * 
         */
        public function updateTargetResize():void
        {
            createBitmapData();
            invalidateDisplayList();
        }
                
        /**
         * 创建位图 
         * 
         */
        protected function createBitmapData():void
        {
            if (bitmapData)
                bitmapData.dispose();
            
            var rect: Rectangle = _target.getBounds(_target);
            if (rect.width && rect.height)
                bitmapData = new BitmapData(rect.width,rect.height,true,0);
        }
        /** @inheritDoc*/
        protected override function updateDisplayList(): void
        {
            super.updateDisplayList();
            
            if (_target && stage)
                renderTarget();
        }
        
        /**
         * 从源图渲染 
         * 
         */
        public function renderTarget():void
        {
            if (!bitmapData)
                return;
            
            var rect: Rectangle = _target.getBounds(_target);
            var m:Matrix = new Matrix();
            m.translate(-rect.x, -rect.y);
            bitmapData.fillRect(bitmapData.rect,0);
            bitmapData.draw(_target,m);    
        }
        
        private function handleTargetResize(event: ResizeEvent): void
        {
            updateTargetResize();
        }
        
        private function handleTargetMove(event: MoveEvent): void
        {
            updateTargetMove();
        }
        
        private function handleTargetUpdateComplete(event: GEvent): void
        {
            updateDisplayList();
        }
                        
        private function addTargetEvents():void
        {
            if (_target && _target is GBase)
            {
                _target.addEventListener(GEvent.UPDATE_COMPLETE, handleTargetUpdateComplete);
                _target.addEventListener(MoveEvent.MOVE, handleTargetMove);
                _target.addEventListener(ResizeEvent.RESIZE, handleTargetResize);
            }
        }
        
        private function removeTargetEvents():void
        {
            if (_target && _target is GBase)
            {
                _target.removeEventListener(GEvent.UPDATE_COMPLETE, handleTargetUpdateComplete);
                _target.removeEventListener(MoveEvent.MOVE, handleTargetMove);
                _target.removeEventListener(ResizeEvent.RESIZE, handleTargetResize);
            }
        }
        /** @inheritDoc*/
        public override function destory():void
        {
            if (destoryed)
                return;
            
            removeTargetEvents();
            if (bitmapData)
                bitmapData.dispose();
            
            super.destory();
        }
    }
}