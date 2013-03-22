package ghostcat.display.movieclip
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundTransform;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    import ghostcat.display.GBase;
    import ghostcat.events.MovieEvent;
    import ghostcat.events.TickEvent;
    import ghostcat.util.Tick;
    import ghostcat.util.Util;
    import ghostcat.util.core.AbstractUtil;
    import ghostcat.util.core.Handler;
    import ghostcat.util.display.DisplayUtil;

    [Event(name="movie_start",type="ghostcat.events.MovieEvent")]
    
    [Event(name="movie_end",type="ghostcat.events.MovieEvent")]
    
    [Event(name="movie_empty",type="ghostcat.events.MovieEvent")]
    
    
    /**
     * 作为GMovieClip和BitmapMovieClip共同的基类。此类不允许实例化。
     * 
     * @author flashyiyi
     * 
     */
    public class GMovieClipBase extends GBase
    {
        protected var _labels:Array;
        protected var _currentFrame:int = 1;
        protected var _totalFrames:int = 1;
        
        /**
         * 是否激活按Label跳转的动画模式
         */
        public var enabledLabelMovie:Boolean = true;
        
        /**
         * 保存着所有的帧上函数
         */
        public static var labelHandlers:Dictionary = new Dictionary();
        
        /**
         * 注册一个根据特定帧标签执行的函数
         * 
         * @param name
         * @param h
         * 
         */        
        public static function registerHandler(name:String,h:Handler):void
        {
            labelHandlers[name] = h;
        }
        
        /**
         * 注册一个根据特定帧标签播放的声音
         * 
         * @param name
         * @param h
         * 
         */        
        public static function registerSound(name:String,s:Sound,loop:int = 1,volume:Number = 1.0,pan:Number = 0):void
        {
            registerHandler(name,new Handler(s.play,[0,loop,new SoundTransform(volume,pan)]));
        }
        
        private var _frameRate:Number = 12;
        
        private var numLoops:int = -1;//循环次数，-1为无限循环
        
        private var nextLabels:Array = [];//Labels列表
        
        private var _queueDestory:Boolean = false;
        
        protected var curLabelIndex:int = 0;//缓存LabelIndex的序号，避免重复遍历
        
        protected var frameTimer:int = 0;//记时器，小于0则需要播放，直到大于0
        

        /**
         * 连接到自己的MovieClip对象
         */
        public var linkMovieClips:Array;
        
        /**
         * 是否在动画结束后暂停 
         */
        public var playOnce:Boolean = true;
        
        /**
         * 设置相同的Label是否重置
         */
        public var resetLabel:Boolean = true;
        
        public function GMovieClipBase(skin:*=null, replace:Boolean=true, paused:Boolean=false)
        {
            AbstractUtil.preventConstructor(this,GMovieClipBase);
            super(skin, replace);
            
            this.enabledTick = true;
            this.paused = paused;
        }
        
        /**
         * 设置帧频，设为NaN表示使用默认帧频，负值则为倒放。
         */        
        public function get frameRate():Number
        {
            if (!isNaN(_frameRate))
                return     _frameRate;
            else if (!isNaN(Tick.frameRate))
                return Tick.frameRate;
            else if (stage)
                return stage.frameRate;
            else
                return NaN;
        }

        public function set frameRate(v:Number):void
        {
            _frameRate = v;
        }
        
        override public function set paused(v:Boolean):void
        {
            if (super.paused != v)
            {
                _paused = v;
                
                if (v)
                    DisplayUtil.stopAll(content as DisplayObjectContainer);
                else
                    DisplayUtil.playAll(content as DisplayObjectContainer);
                
                refreshEnabledTickHandler();
            }
        }
        
        override public function set enabledTick(v:Boolean):void
        {
            if (super.enabledTick != v)
            {
                _enabledTick = v;
                
                refreshEnabledTickHandler();
            }
        }
        
        /**
         * 获得标签的序号
         *  
         * @param labelName
         * @return 
         * 
         */
        public function getLabelIndex(labelName:String):int
        {
            var currLabels:Array = labels;
            if (!currLabels)
                return -1;
            
            var len:int = currLabels.length;
            for (var i:int = 0;i < len;i++)
            {
                if ((currLabels[i] as FrameLabel).name == labelName)
                    return i;
            }
            return -1;
        }
        
        /**
         * 是否存在某个标签
         * 
         * @param labelName
         * @return 
         * 
         */
        public function hasLabel(labelName:String):Boolean
        {
            return getLabelIndex(labelName) != -1;
        }
        
        /**
         * 设置循环次数 
         * @param loop
         * 
         */
        public function setLoop(loop:int):void
        {
            this.numLoops = loop;
        }
        
        /**
         * 设置当前动画 
         * @param labelName        动画名称
         * @param repeat        动画循环次数，设为-1为无限循环
         * @param clearQueue    是否清除动画队列
         */
                 
        public function setLabel(labelName:String, repeat:int=-1, clearQueue:Boolean = true):void
        {
            if (clearQueue)
                this.clearQueue();
            
            var index:int = labelName ? getLabelIndex(labelName) : 0;
            
            if (index != -1)
            {
                numLoops = repeat;
                if (!resetLabel && index == curLabelIndex)
                    return;
                
                currentFrame  = (_frameRate < 0) ? getLabelEnd(index) : getLabelStart(index);
                curLabelIndex = index;
                
                dispatchMovieStart(labelName);
                
                if (GMovieClipBase.labelHandlers[labelName])
                    (GMovieClipBase.labelHandlers[labelName] as Handler).call();
            }
            else
            {
                dispatchMovieEnded(labelName);
                
                dispatchMovieEmpty(labelName);
                
                dispatchMovieError(labelName);
            }
            
            if (_totalFrames <= 1 || !content)
            {   
                dispatchMovieEnded(labelName);
                
                dispatchMovieEmpty(labelName);
            }
        }
        
        /**
         *
         * 将动画推入列表，延迟播放
         * @param labelName        动画名称
         * @param repeat        动画循环次数，设为-1为无限循环
         * 
         */
                 
        public function queueLabel(labelName:String, repeat:int=-1):void
        {
            nextLabels.push([labelName, repeat]);
        }
        
        /**
         * 清除动画队列 
         */
                 
        public function clearQueue():void
        {
            nextLabels.length = 0;
            _queueDestory = false;
        }
        
        /**
         * 初始化动画
         * 
         */
        public function reset():void
        {
            setLabel(null);
        }
        
        protected override function tickHandler(event:TickEvent):void
        {
            if (numLoops == 0 || _frameRate == 0 || _totalFrames <= 1)
                return;
            
            frameTimer -= event.interval;
            while (numLoops != 0 && frameTimer < 0) 
            {
                if (hasReachedLabelEnd())
                {
                    if (numLoops > 0)
                        numLoops--;
                    
                    if (numLoops == 0)
                    {
                        dispatchMovieEnded(); 
                        
                        if (nextLabels.length > 0)
                        {
                            setLabel(nextLabels[0][0], nextLabels[0][1], false);
                            nextLabels.splice(0, 1);
                        }
                        else 
                        {
                            dispatchMovieEmpty();
                                
                            if (_queueDestory)
                                destory();
                            
                            frameTimer = 0;//停止动画时需要将延时重置为0
                        }
                    }
                    else 
                    {
                        loopBackToStart();
                    }
                }
                else
                {
                    nextFrame()
                }
                
                frameTimer += 1000 / (_frameRate > 0 ? _frameRate : -_frameRate);
            }
        }
        
        /**
         * 当前帧标签内的位置
         * @return 
         * 
         */
        public function get frameInLabel():int
        {
            return _currentFrame - getLabelStart(curLabelIndex) + 1;
        }
        
        public function set frameInLabel(v:int):void
        {
            currentFrame = getLabelStart(curLabelIndex) + v - 1;
        }
        
        /**
         * 回到当前动画的第一帧（反向播放则是最后一帧）
         */
        public function loopBackToStart():void
        {
            currentFrame = (_frameRate < 0) ? getLabelEnd(curLabelIndex) : getLabelStart(curLabelIndex);
        }
        
        //检测是否已经到达当前区段的尾端（倒放则相反）
        private function hasReachedLabelEnd():Boolean
        {
            if (_frameRate < 0)
                return _currentFrame <= getLabelStart(curLabelIndex);
            else
                return _currentFrame >= getLabelEnd(curLabelIndex);
        }
        
        //取得Label的头部
        public function getLabelStart(labelIndex:int):int
        {
            var currLabels:Array = enabledLabelMovie ? _labels : null;
            return (currLabels && currLabels.length > 0) ? currLabels[labelIndex].frame : 1;
        }
        
        //取得Label的尾端
        public function getLabelEnd(labelIndex:int):int
        {
            var currLabels:Array = enabledLabelMovie ? _labels : null;
            if (currLabels && labelIndex + 1 < currLabels.length)
                return currLabels[labelIndex + 1].frame - 1;
            else
                return _totalFrames;
        }
        
        /** @inheritDoc*/
        public override function destory():void
        {
            paused = true;
            
            super.destory();
        }
        
        /**
         * 是否有帧标签 
         * @return 
         * 
         */
        public function hasLabels():Boolean
        {
            return enabledLabelMovie && _labels && _labels.length > 0;
        }
        
        /**
         * 所有标签，类型为FrameLabel
         * @return 
         * 
         */
        public function get labels():Array
        {
            return enabledLabelMovie ? _labels : null;
        }
        
        /**
         * 当前动画名称
         * @return 
         * 
         */    
        public function get curLabelName():String
        {
            for (var i:int = labels.length - 1;i>=0;i--)
            {
                var frameLabel:FrameLabel = labels[i] as FrameLabel;
                if (frameLabel.frame <= _currentFrame)
                    return frameLabel.name;
            }
            return null;
        }
        
        /**
         * 当前帧
         * 
         * @return 
         * 
         */
        public function get currentFrame():int
        {
            return _currentFrame;
        }
        
        public function set currentFrame(frame:int):void
        {
            _currentFrame = frame;
            if (linkMovieClips)
            {
                for each (var mc:GMovieClipBase in linkMovieClips)
                    mc.currentFrame = frame;
            }
        }
        
        /**
         * 总帧数
         * 
         * @return 
         * 
         */
        public function get totalFrames():int
        {
            return _totalFrames;
        }
        
        /**
         * 下一帧（倒放时则是上一帧）
         * 
         */
        public function nextFrame():void
        {
            (_frameRate < 0) ? currentFrame -- : currentFrame ++;
        }
        
        /**
         * 连接到另一个动画，由目标动画控制自己的帧跳转
         * @param target
         * 
         */
        public function linkTo(target:GMovieClipBase):void
        {
            this.paused = true;
            if (!target.linkMovieClips)
                target.linkMovieClips = [];
            
            target.linkMovieClips.push(this);
        }
        
        /**
         * 解除动画连接 
         * @param target
         * 
         */
        public function removeLinkFrom(target:GMovieClipBase):void
        {
            this.paused = false;
            Util.remove(target.linkMovieClips,this);
            
            if (target.linkMovieClips.length == 0)
                target.linkMovieClips = null;
        }
        
        /**
         * 播放动画后销毁自身
         * 
         */
        public function queueDestory():void
        {
            _queueDestory = true;
        }
        
        /**
        *  发送动画播放结束事件
        */
        protected function dispatchMovieEnded(labelName:String = null):void
        {
            if (this.hasEventListener(MovieEvent.MOVIE_END))
            {
                var e:MovieEvent = new MovieEvent(MovieEvent.MOVIE_END);
                e.labelName = labelName ? labelName : curLabelName;
                dispatchEvent(e);
            }
        }
        
        /**
        *  发送动画播放错误事件
        */
        protected function dispatchMovieError(labelName:String = null):void
        {
            if (this.hasEventListener(MovieEvent.MOVIE_ERROR))
            {
                var e:MovieEvent = new MovieEvent(MovieEvent.MOVIE_ERROR);
                e.labelName = labelName ? labelName : curLabelName;
                dispatchEvent(e);
            }
        }
        
        /**
        *  发送动画播放开始事件
        */
        protected function dispatchMovieStart(labelName:String = null):void
        {
            if (this.hasEventListener(MovieEvent.MOVIE_START))
            {
                var e:MovieEvent = new MovieEvent(MovieEvent.MOVIE_START);
                e.labelName = labelName ? labelName : curLabelName;
                dispatchEvent(e);
            }
        }
        
        /**
         *  发送动画播放开始事件
         */
        protected function dispatchMovieEmpty(labelName:String = null):void
        {
            if (this.hasEventListener(MovieEvent.MOVIE_EMPTY))
            {
                var e:MovieEvent = new MovieEvent(MovieEvent.MOVIE_EMPTY);
                e.labelName = labelName ? labelName : curLabelName;
                dispatchEvent(e);
            }
        }
        
        /**
        *   刷新动画的Tick监听和动画播放是否停止
        */ 
        protected function refreshEnabledTickHandler():void
        {
            // 对于动画，只有在总帧数大于1时才添加监听事件
            if (!_paused && (_totalFrames > 1) && _enabledTick)
                Tick.instance.addTickHandler(tickHandler);
            else
                Tick.instance.removeTickHandler(tickHandler);
        }
    }
}