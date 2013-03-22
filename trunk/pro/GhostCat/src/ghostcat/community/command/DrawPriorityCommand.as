package ghostcat.community.command
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    /**
     * 景深排序
     * 
     * @author flashyiyi
     * 
     */
    public final class DrawPriorityCommand
    {
        /**
         * 按y轴排序
         *  
         * @param d1
         * @param d2
         * 
         */
        public static function SORTY(d1:DisplayObject,d2:DisplayObject):Boolean
        {
            if (d1.parent != d2.parent)
                return false;
            
            var parent:DisplayObjectContainer = d1.parent;
            
            if (!parent)
                return false;
            
            var i1:int = parent.getChildIndex(d1);
            var i2:int = parent.getChildIndex(d2);
            var isHighIndex:Boolean = i1 > i2; 
            var isHighValue:Boolean = d1.y > d2.y;
            
            if (isHighIndex != isHighValue)
            {
                parent.setChildIndex(d1,i2);
                return true;
            }
            return false;
        }
        
        /**
         * 按对象的priority值排序
         * 
         * @param d1
         * @param d2
         * 
         */
        public static function SORTZ(d1:DisplayObject,d2:DisplayObject):Boolean
        {
            if (d1.parent != d2.parent)
                return false;
            
            var parent:DisplayObjectContainer = d1.parent;
            
            if (!parent)
                return false;
            
            var i1:int = parent.getChildIndex(d1);
            var i2:int = parent.getChildIndex(d2);
            var isHighIndex:Boolean = i1 > i2; 
            var isHighValue:Boolean = d1["priority"] > d2["priority"];
            
            if (isHighIndex != isHighValue)
            {
                parent.setChildIndex(d1,i2);
                return true;
            }
            return false;
        }
        
        /**
         * 首先按priority值排序，然后按Y轴排序
         *  
         * @param d1
         * @param d2
         * 
         */
        public static function SORTZY(d1:DisplayObject,d2:DisplayObject):Boolean
        {
            if (d1.parent != d2.parent)
                return false;
            
            var parent:DisplayObjectContainer = d1.parent;
            
            if (!parent)
                return false;
            
            var i1:int = parent.getChildIndex(d1);
            var i2:int = parent.getChildIndex(d2);
            var isHighIndex:Boolean = i1 > i2; 
            var isHighValue:Boolean;
            
            if (d1["priority"] && d2["priority"])
                isHighValue = d1["priority"] > d2["priority"];
            else if (d1["priority"])
                isHighValue = true;
            else if (d2["priority"])
                isHighValue = false;
            else
                isHighValue = d1.y > d2.y;
            
            if (isHighIndex != isHighValue)
            {
                parent.setChildIndex(d1,i2);
                return true;
            }
            return false;
        }

    }
}