package ghostcat.display
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.PixelSnapping;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.geom.Rectangle;
    import flash.utils.getDefinitionByName;
    
    import ghostcat.FrameworkClasses;
    import ghostcat.events.GEvent;
    import ghostcat.operation.FunctionOper;
    import ghostcat.util.core.ClassFactory;
    import ghostcat.util.display.DisplayUtil;

    /**
     * 基类，用于对图元进行包装。replace参数为false时将不会对源图元产生影响，可作为单独的控制类使用
     * replace参数为true时，将会将Skin替换成此类。
     * 
     * 增加嵌套而不使用逻辑类是考虑到实际应用时更方便，而且可以更容易实现更替内容和旋转等操作。
     * 
     * @author flashyiyi
     * 
     */    
    public class GSprite extends Sprite implements IDisplayObjectContainer
    {
        ghostcat.FrameworkClasses;
        
        private var _content:DisplayObject;
        
        private var _replace:Boolean = true;
        
        /**
        * 内容变更前时的回调函数，全局变更监听
        */ 
        public static var preContentChangeHandler:Function = null;
        
        /**
         * 内容变更后时的回调函数，全局变更监听
         */
        public static var bitmapCacheHandler:Function = null;
        
        /**
        *   传入可用的输入设备
        */ 
        public static var inputManager:IEventDispatcher;
        
        /**
         * 是否在移出显示列表的时候删除自身
         */        
        public var destoryWhenRemove:Boolean = false;
        
        /**
         * 是否在更换Content时销毁原有Content
         */
        public var autoDestoryContent:Boolean = true;
        
        /**
         * 是否用修改Content的大小来取代修改自身大小（可以保留Content的九宫格）
         */
        public var resizeContent:Boolean = true;
        
        /**
         * 是否初始化
         */
        public var initialized:Boolean;
        
        /**
         * 是否已经被销毁
         */
        public var destoryed:Boolean = false;
        
        /**
         * 是否在第一次设置content时接受content的坐标 
         */        
        public var acceptContentPosition:Boolean = true;
                
        /**
         * 内容是否初始化
         */
        protected var contentInited:Boolean = false;
        
        /**
         * 是否隐藏显示内容
         */
        private var _hideContent:Boolean;
        
        
        /**
         * 参数与setContent方法相同
         * 
         */        
        public function GSprite(skin:*=null,replace:Boolean=true)
        {
            super();
            
            //保存舞台实例
//            if (root && !RootManager.initialized)
//                RootManager.root = root as Sprite;
            
            addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
            addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
        
            setContent(skin,replace);
        }
        
        /**
         * 设置替换方式。此属性务必在设置skin之前设置，否则会导致源图像被破坏，达不到replace为false时的效果。 
         * @return 
         * 
         */        
        public function get replace():Boolean
        {
            return _replace;
        }
        
        public function set replace(v:Boolean):void
        {
            _replace = v;
            setContent(_content,v);
        }
        /**
         * 设置皮肤 
         * @return 
         * 
         */        
        public function get skin():*
        {
            return _content;
        }
        
        public function set skin(v:*):void
        {
            setContent(v,replace);
        }
        
        /**
         *
         * 当前容纳的内容
         * @return 
         * 
         */        
        
        public function get content():DisplayObject
        {
            return _content;
        }
        
        public function set content(v:DisplayObject):void
        {
            _content = v;
        }
        
        /**
         * 是否暂时移除Content 
         * @return 
         * 
         */
        public function get hideContent():Boolean
        {
            return _hideContent;
        }
        
        public function set hideContent(value:Boolean):void
        {
            if (!content)
                return;
            
            _hideContent = value;
            if (value)
            {
                if (content.parent == this)
                    removeChild(content)
            }
            else
            {
                if (content.parent != this)
                    addChild(content);
            }
        }
        
        public override function set width(value:Number) : void
        {
            if (content && resizeContent)
                content.width = value;
            else
                super.width = value;
        }
        
        public override function set height(value:Number) : void
        {
            if (content && resizeContent)
                content.height = value;
            else
                super.height = value;
        }
        
//        public override function get scrollRect():Rectangle
//        {
//            if (content && resizeContent)
//                return content.scrollRect;
//            else
//                return super.scrollRect;
//        }
//        
//        public override function set scrollRect(value:Rectangle):void
//        {
//            if (content && resizeContent)
//                content.scrollRect = value;
//            else
//                super.scrollRect = value;
//        }
        
        protected function delaySetContent(skin:* = null, replace:Boolean = true):void
        {
            setContent(skin, replace);
            
            // 等待资源的下载，然后延迟设置content，并发送设置content完成事件
            if (content)
                this.dispatchEvent(new Event(Event.COMPLETE));
        }
        
        /**
         * 设置皮肤。
         * 
         * @param skin        皮肤    
         * @param replace    是否替换原图元
         * 
         */
        public function setContent(skin:*,replace:Boolean=true):void
        {            
            if (skin is String)
            {
                // 在设置content之前的回调函数,主要是资源在使用之前有一个预处理
                if (preContentChangeHandler != null)
                {
                    skin = preContentChangeHandler(skin, true, new FunctionOper(delaySetContent, [skin, replace], this));
                }
                else
                    skin = getDefinitionByName(skin as String);
                
                 if (!skin)
                    return;
            }
            
            if (skin is Class)
                skin = new ClassFactory(skin);
            
            if (skin is ClassFactory)
                skin = (skin as ClassFactory).newInstance();
            
            if (_content == skin)
                return;
            
            if (skin is BitmapData)
                skin = new Bitmap(skin as BitmapData, PixelSnapping.AUTO, true);
            
            if (skin is Bitmap)
                (skin as Bitmap).smoothing = true;
            
            if (_content && _content.parent == this)
            {
                if (_content is IGBase && autoDestoryContent)
                    (_content as IGBase).destory();
                
                if (_content.parent)
                    $removeChild(_content);
            }
            
            var oldIndex:int;
            var oldParent:DisplayObjectContainer;
            
            if (replace && skin)
            {
                //新设置内容的时候，获取内容的坐标
                if (acceptContentPosition && !contentInited)
                {
                    if ((0 == x) && (0 == y))
                    {
                        this.x = skin.x;
                        this.y = skin.y;
                    }
                        
                    skin.x = skin.y = 0;
                }
                
                if (_content == null)
                {
                    //在最后才加入舞台
                    if (skin.parent)
                    {
                        oldParent = skin.parent;
                        oldIndex = skin.parent.getChildIndex(skin);
                    }
                }
                
                $addChild(skin);
                
                if (!contentInited)
                {
                    this.visible = skin.visible;
                    skin.visible = true;
                    this.name = skin.name;
                }
            }
            _content = skin;
            
            if (oldParent && !(oldParent is Loader) && oldParent != this)
                oldParent.addChildAt(this,oldIndex);
            
            // 内容变更后的回调
            if (bitmapCacheHandler != null)
                bitmapCacheHandler.apply(null, [_content]);
            
            this.contentInited = true;
        }
        
        protected function addedToStageHandler(event:Event):void
        {
            if (!this.initialized)
            {
                init();
                
                this.initialized = true;
                
                dispatchEvent(new GEvent(GEvent.CREATE_COMPLETE));
            }
        }
        
        protected function removedFromStageHandler(event:Event):void
        {
            if (destoryWhenRemove)
            {
                this.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
                
                destory();
            }
        }
        
        /**
         *
         * 初始化方法，在第一次被加入显示列表时调用 
         * 
         */        
        protected function init():void
        {
        }
        
        /**
         * 销毁方法
         * 
         */
        public function destory():void
        {
            if (destoryed)
                return;
            
            if (content && (content is MovieClip))
                DisplayUtil.stopAll((content as MovieClip));

            if (bitmapCacheHandler != null)
                bitmapCacheHandler.apply(null, [_content, false]);
            
            DisplayUtil.clearAllBitmap(this);
            
            removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
            removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
            
            if (content is IGBase && autoDestoryContent)
                (content as IGBase).destory();
            content = null;

            // 清除所有的子孩子
            if (autoDestoryContent)
            {
                while (numChildren > 0)
                {
                    var child:DisplayObject = this.getChildAt(0);
                    if (child is IGBase)
                        (child as IGBase).destory();
                    if (child && child.parent == this)
                        this.removeChild(child);
                }
            }
            
            if (parent)
                parent.removeChild(this);
            
            destoryed = true;
        }
        
        public function $addChild(v:DisplayObject):DisplayObject
        {
            return super.addChild(v);
        }
        
        public function $addChildAt(v:DisplayObject,index:int):DisplayObject
        {
            return super.addChildAt(v,index);
        }
        
        public function $removeChild(v:DisplayObject):DisplayObject
        {
            return super.removeChild(v);
        }
        
        public function $removeChildAt(index:int):DisplayObject
        {
            return super.removeChildAt(index);
        }
        
        public function $getChildAt(index:int):DisplayObject
        {
            return super.getChildAt(index);
        }
        
        public function $getChildByName(name:String):DisplayObject
        {
            return super.getChildByName(name);
        }
        
        public function $getChildIndex(child:DisplayObject):int
        {
            return super.getChildIndex(child);
        }
    }
}