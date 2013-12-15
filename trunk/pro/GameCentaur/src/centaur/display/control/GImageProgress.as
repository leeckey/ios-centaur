package centaur.display.control
{
    import centaur.utils.PublicUtil;
    
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    
    import ghostcat.display.GBase;
    import ghostcat.display.GNoScale;
    import ghostcat.ui.UIConst;
    import ghostcat.ui.controls.GBuilderBase;

    /**
     *  图片式进度条，将图片分层，并使用遮罩显示进度效果
     *  @author wangq 2011.08.02
     */
    public class GImageProgress extends GBuilderBase
    {
        /**
        *  背景图层
        */ 
        public var backgroundImage:GBase;
        
        /**
        *  进度图层
        */ 
        public var progressImage:GBase;
        
        /**
        *  水平进度条
        */ 
        public var type:String = UIConst.HORIZONTAL;
        
        /**
        *  进度的方向，默认从左到右，从上到下为正向
        */ 
        public var direction:Boolean = true;
        
        /**
        *  遮罩
        */ 
        protected var _mask:Shape;
        
        /**
        *   当前进度
        */ 
        private var _progress:Number = 1.0;
        
        public function GImageProgress(skin:* = null, type:String = UIConst.HORIZONTAL, direction:Boolean = true, replace:Boolean = true)
        {
            this.type = type;
            this.direction = direction;
            super(skin, replace);
            
            setup();
        }
        
        override public function destory():void
        {
            if (backgroundImage)
                backgroundImage.destory();
            if (progressImage)
                progressImage.destory();
            
            super.destory();
        }
        
        /**
        *   设置进度，返回值表示是否发生修改
        */ 
        public function setprogress(progress:Number):Boolean
        {
            progress = PublicUtil.clamp(progress, 0, 1);
            if (!PublicUtil.numberCompare(progress, _progress, 0.01))
            {
                _progress = progress;
                drawMask(progressImage, progress);   
                return true;
            }
            
            return false;
        }
        
        public function getProgress():Number
        {
            return _progress;
        }
        
        public function reset():void
        {
            drawMask(progressImage);
        }
        
        protected function setup():void
        {
            drawMask(progressImage);
            if (progressImage)
                progressImage.addChild(_mask);
        }
        
        /**
        *  渲染遮罩
        */ 
        protected function drawMask(target:DisplayObject, progress:Number = 1.0):void
        {
            if (!target)
                return;
            
            if (!_mask)
                _mask = new Shape();
            
            var imageWidth:int = target.width;
            var imageHeight:int = target.height;
            
            _mask.graphics.clear();
            _mask.graphics.beginFill(0xffffff);
            
            if (type == UIConst.HORIZONTAL)
            {
                if (direction)
                    _mask.graphics.drawRect(0, 0, imageWidth * progress, imageHeight);
                else
                    _mask.graphics.drawRect(imageWidth * (1 - progress), 0, imageWidth * progress, imageHeight);
            }
            else if (type == UIConst.VERTICAL)
            {
                if (direction)
                    _mask.graphics.drawRect(0, 0, imageWidth, imageHeight * progress);
                else
                    _mask.graphics.drawRect(0, imageHeight * (1 - progress), imageWidth, imageHeight * progress);
            }
            _mask.graphics.endFill();
            
            target.mask = _mask;
        }
    }
}