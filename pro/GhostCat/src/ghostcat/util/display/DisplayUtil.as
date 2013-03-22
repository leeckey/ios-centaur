package ghostcat.util.display
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import ghostcat.display.GBase;
    import ghostcat.display.IGBase;
    

    /**
     * 一些用于图形的公用静态方法
     * @author flashyiyi
     * 
     */
    public final class DisplayUtil
    {
        /**
         * 检测对象是否在屏幕中
         * @param displayObj    显示对象
         * 
         */
        public static function inScreen(displayObj:DisplayObject):Boolean
        {
            if (displayObj.stage == null)
                return false;
            
            var screen:Rectangle = Geom.getRect(displayObj.stage);
            return screen.containsRect(displayObj.getBounds(displayObj.stage));
        }
        
        /**
         * 添加到对象之后
         * @param container
         * @param child
         * @param target
         * 
         */
        public static function addChildAfter(child:DisplayObject,target:DisplayObject):void
        {
            target.parent.addChildAt(child,target.parent.getChildIndex(target) + 1);
        }
        
        /**
         * 添加到对象之前
         * @param container
         * @param child
         * @param target
         * 
         */
        public static function addChildBefore(child:DisplayObject,target:DisplayObject):void
        {
            target.parent.addChildAt(child,target.parent.getChildIndex(target));
        }
        
        /**
         * 获得子对象数组 
         * @param container
         * 
         */
        public static function getChildren(container:DisplayObjectContainer):Array
        {
            var result:Array = [];
            for (var i:int = 0;i < container.numChildren;i++) 
                result.push(container.getChildAt(i));
            
            return result;
        }
        
        /**
         * 移除所有子对象
         * @param container    目标
         * 
         */
        public static function removeAllChildren(container:DisplayObjectContainer):void
        {
            while (container.numChildren) 
                container.removeChildAt(0);
        }
        
        /**
         * 批量增加子对象 
         * 
         */
        public static function addAllChildren(container:DisplayObjectContainer,children:Array):void
        {
            for (var i:int = 0;i < children.length;i++)
            {
                if (children[i] is Array)
                    addAllChildren(container,children[i] as Array);
                else    
                    container.addChild(children[i])
            }
        }
        
        /**
         * 将显示对象移至顶端
         * @param displayObj    目标
         * 
         */        
        public static function moveToHigh(displayObj:DisplayObject):void
        {
            var parent:DisplayObjectContainer = displayObj.parent;
            if (parent)
            {
                var lastIndex:int = parent.numChildren - 1;
                if (parent.getChildIndex(displayObj) < lastIndex)
                    parent.setChildIndex(displayObj, lastIndex);
            }
        }
        
        /**
         * 同时设置mouseEnabled以及mouseChildren。
         * 
         */        
        public static function setMouseEnabled(displayObj:DisplayObjectContainer,v:Boolean):void
        {
            displayObj.mouseChildren = displayObj.mouseEnabled = v;
        }
        
        /**
         * 复制显示对象
         * @param v
         * 
         */
        public static function cloneDisplayObject(v:DisplayObject):DisplayObject
        {
            var result:DisplayObject = v["constructor"]();
            result.filters = result.filters;
            result.transform.colorTransform = v.transform.colorTransform;
            result.transform.matrix = v.transform.matrix;
            if (result is Bitmap)
                (result as Bitmap).bitmapData = (v as Bitmap).bitmapData;
            return result;
        }
        
        /**
         * 获取舞台Rotation
         * 
         * @param displayObj    显示对象
         * @return 
         * 
         */        
        public static function getStageRotation(displayObj:DisplayObject):Number
        {
            var currentTarget:DisplayObject = displayObj;
            var r:Number = 1.0;
            
            while (currentTarget && currentTarget.parent != currentTarget)
            {
                r += currentTarget.rotation;
                currentTarget = currentTarget.parent;
            }
            return r;
        }
        
        /**
         * 获取舞台缩放比
         *  
         * @param displayObj
         * @return 
         * 
         */
        public static function getStageScale(displayObj:DisplayObject):Point
        {
            var currentTarget:DisplayObject = displayObj;
            var scale:Point = new Point(1.0,1.0);
            
            while (currentTarget && currentTarget.parent != currentTarget)
            {
                scale.x *= currentTarget.scaleX;
                scale.y *= currentTarget.scaleY;
                currentTarget = currentTarget.parent;
            }
            return scale;
        }
        
        /**
         * 获取舞台Visible
         * 
         * @param displayObj    显示对象
         * @return 
         * 
         */        
        public static function getStageVisible(displayObj:DisplayObject):Boolean
        {
            var currentTarget:DisplayObject = displayObj;
            while (currentTarget && currentTarget.parent != currentTarget)
            {
                if (currentTarget.visible == false) 
                    return false;
                currentTarget = currentTarget.parent;
            }
            return true;
        }
        
        /**
         * 判断对象是否在某个容器中 
         * @param displayObj
         * @param container
         * @return 
         * 
         */
        public static function isInContainer(displayObj:DisplayObject,container:DisplayObjectContainer):Boolean
        {
            var currentTarget:DisplayObject = displayObj;
            while (currentTarget && currentTarget.parent != currentTarget)
            {
                if (currentTarget == container) 
                    return true;
                currentTarget = currentTarget.parent;
            }
            return false;
        }
        
        /**
         *  停止所有的动画，包括子类
         */ 
        public static function stopAll(content:DisplayObjectContainer, containSelf:Boolean = true):void
        {
            if (!content)
                return;
            
            if (containSelf && (content is MovieClip))
                (content as MovieClip).stop();
            
            var childrenNum:int = content.numChildren;
            if (childrenNum > 0)
            {
                var child:DisplayObjectContainer;
                for (var i:int; i < childrenNum; ++i)
                {
                    child = content.getChildAt(i) as DisplayObjectContainer;
                    if (!child)
                        continue;
                    
                    if (child.numChildren)
                        stopAll(child, containSelf);
                    else if (child is MovieClip)
                        (child as MovieClip).stop();
                }
            }
        }
        
        /**
         *  停止所有的动画，包括子类
         */ 
        public static function playAll(content:DisplayObjectContainer, containSelf:Boolean = false):void
        {
            if (!content)
                return;
            
            if (containSelf && (content is MovieClip))
                (content as MovieClip).play();
            
            var childrenNum:int = content.numChildren;
            if (childrenNum > 0)
            {
                var child:DisplayObjectContainer;
                for (var i:int; i < childrenNum; ++i)
                {
                    child = content.getChildAt(i) as DisplayObjectContainer;
                    if (!child)
                        continue;
                    
                    if (child.numChildren)
                        playAll(child, true);
                    else if (child is MovieClip)
                        (child as MovieClip).play();
                }
            }
        }
        
        /**
        *  清除元件的所有位图，回收内存
        */ 
        public static function clearAllBitmap(container:DisplayObjectContainer):void
        {
            if (!container)
                return;
            
            var numChildren:int = container.numChildren;
            for (var i:int = 0; i < numChildren; ++i)
            {
                var child:DisplayObject = container.getChildAt(i);
                if (child is Bitmap)
                {
                    var bitmapData:BitmapData = (child as Bitmap).bitmapData;
                    if (bitmapData)
                        bitmapData.dispose();
                    (child as Bitmap).bitmapData = null;
                }
                else if (child is DisplayObjectContainer)
                {
                    clearAllBitmap(child as DisplayObjectContainer);
                }
            }
        }
        
        public static function setEnabledTick(target:DisplayObjectContainer, value:Boolean, specifiedClass:Class = null, recursive:Boolean = true):void
        {
            if (!target)
                return;
            
            if (!specifiedClass)
                specifiedClass = GBase;
            
            if (target is IGBase && (target is specifiedClass))
                (target as IGBase).enabledTick = value;
            
            if (!recursive)
                return;
            
            var numChildren:int = target.numChildren;
            for (var i:int = 0; i < numChildren; ++i)
            {
                var child:DisplayObject = target.getChildAt(i);
                if (child is DisplayObjectContainer)
                    setEnabledTick(child as DisplayObjectContainer, value, specifiedClass, recursive);
            }
        }
    }
}