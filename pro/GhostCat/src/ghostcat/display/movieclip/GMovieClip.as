package ghostcat.display.movieclip
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import ghostcat.display.GSprite;
    import ghostcat.util.display.DisplayUtil;
    
    /**
     * 动画控制类，可以通过setLabel, queueLabel将动画推入列表，实现动画的灵活控制。这种方法可以非常简单地实现多方向行走，表情动作系统。
     * frameRate可以设置播放速度。采用了getTimer的机制，播放速度不会受到浏览器和机器配置的影响。
     * 
     * 由于MovieClip播放的异步以及播放速度的不稳定特性，不断执行gotoAndStop等方法时将会造成子动画播放不正常，
     * 请尽可能避免在动画内再放置“影片剪辑”，而以“图形”代替。
     * 
     * 设置paused=false时和原本的MovieClip行为相同。
     * 
     * @author flashyiyi
     * 
     */    
    
    public class GMovieClip extends GMovieClipBase
    {
        /**
        *  动画切换时的帧事件
        */
        public static const FRAME_EVENT:String = "frameEvent_";
        
        /**
         * 时间线对象 
         */
        public var timeLine:TimeLine;
        
        /**
        *  内容数组参数
        */ 
        protected var _contentParam:Array;
        
        /**
         * 
         * @param mc    目标动画
         * @param replace    是否替换
         * @param paused    是否暂停
         * 
         */
        public function GMovieClip(mc:*=null, replace:Boolean=true, paused:Boolean=false)
        {
            super(mc, replace, paused);
        }
        
        override public function destory():void
        {
            if (timeLine)
                timeLine.destory();
            timeLine = null;
            
            super.destory();
        }
        
        /**
         * 获得当前动画 
         * @return 
         * 
         */
        public function get mc():MovieClip
        {
            return content as MovieClip;
        }
        /** @inheritDoc*/
        public override function setContent(skin:*, replace:Boolean=true):void
        {
            super.setContent(skin,replace);
            
            if (mc)
            {
                timeLine = new TimeLine(mc);
                mc.stop();
                
                _contentParam = [mc];
                
                initMovieData();
                
                //最开始的初始化，当设置了Label后，将首先在第一个Label内循环
                reset();
                
                // 动画内容变更，刷新一下tick处理
                refreshEnabledTickHandler();
            }
        }
        /** @inheritDoc*/
        public override function get curLabelName():String
        {
            return timeLine ? timeLine.curLabelName : null;
        }
        /** @inheritDoc*/
        public override function getLabelIndex(labelName:String):int
        {
            return timeLine ? timeLine.getLabelIndex(labelName) : -1;
        }
        
        /** @inheritDoc*/
        public override function set currentFrame(frame:int):void
        {
            if (frame < 1)
                frame = 1;
            if (frame > _totalFrames)
                frame = _totalFrames;
            
            if (_currentFrame == frame)
                return;
            
            super.currentFrame = frame;
            
            var movie:MovieClip = content as MovieClip;
            if (movie)
            {
                if (movie)
                    movie.addFrameScript(frame - 1, onFrameScriptHandler);
                
                var mcFrame:int = movie.currentFrame;
                if (frame == mcFrame + 1) 
                    movie.nextFrame();
                else if (frame == mcFrame - 1)
                    movie.prevFrame();
                else
                    movie.gotoAndStop(frame);
                
                // 保存当前的位图缓存
                if (bitmapCacheHandler != null)
                    bitmapCacheHandler.apply(null, _contentParam);
            }
        }
        
        /**
         * 将动画缓存为位图并转化为GBitmapMovieClip对象
         * 注意这个缓存是需要时间的，如果要在完全生成GBitmapMovieClip对象后进行一些操作，可监听GBitmapMovieClip的complete事件
         * 
         * @param rect        绘制范围
         * @param start        起始帧
         * @param len        长度
         * @param immediately    是否立即显示
         * 
         * @return 
         * 
         */
        public function toGBitmapMovieClip(rect:Rectangle=null,start:int = 1,len:int = -1,immediately:Boolean = false):GBitmapMovieClip
        {
            var v:GBitmapMovieClip = new GBitmapMovieClip();
            v.createFromMovieClip(mc,rect,start,len,immediately);
            return v;
        }
        
        protected function onFrameScriptHandler():void
        {
            var movie:MovieClip = content as MovieClip;
            if (!movie)
                return;
            
            var eventName:String = getFrameEventName(movie.currentFrame);
            if (eventName && this.hasEventListener(eventName))
                this.dispatchEvent(new Event(eventName));
        }
        
        protected function getFrameEventName(frame:int):String
        {
                return FRAME_EVENT + String(frame);
            
            return null;
        }
        
        protected function initMovieData():void
        {
            if (timeLine)
            {
                _labels = timeLine.labels;
                _totalFrames = timeLine.totalFrames;
            }
        }
    }
}