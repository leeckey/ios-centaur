package ghostcat.community.command
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    
    import ghostcat.display.game.Display45Util;
    import ghostcat.util.display.ColorUtil;

    /**
     * 45度角景深排序
     * 
     * @author flashyiyi
     * 
     */
    public final class DrawPriority45Command
    {
        /**
         * 45度角排序（按格子）
         *  
         * @param d1
         * @param d2
         * 
         */
        public static function SORT_45(d1:DisplayObject,d2:DisplayObject):Boolean
        {
            if (d1.parent != d2.parent)
                return false;
            
            var parent:DisplayObjectContainer = d1.parent;
            
            if (!parent)
                return false;
            
            var i1:int = parent.getChildIndex(d1);
            var i2:int = parent.getChildIndex(d2);
            var isHighIndex:Boolean = i1 > i2; 
            var isHighValue:Boolean = Display45Util.SORT_45(d1,d2) > 0;
            
            if (isHighIndex != isHighValue)
            {
                parent.setChildIndex(d1,i2);
                return true;
            };
            return false;
        }
        
        /**
         * 45度角排序（按大小范围）
         *  
         * @param d1
         * @param d2
         * 
         */
        public static function SORT_SIZE_45(d1:DisplayObject,d2:DisplayObject):Boolean
        {
            if (d1.parent != d2.parent)
                return false;
            
            var parent:DisplayObjectContainer = d1.parent;
            
            if (!parent)
                return false;
            
            var i1:int = parent.getChildIndex(d1);
            var i2:int = parent.getChildIndex(d2);
            var isHighIndex:Boolean = i1 > i2; 
            var isHighValue:Boolean = Display45Util.SORT_SIZE_45(d1,d2) > 0;
            
            if (isHighIndex != isHighValue)
            {
                parent.setChildIndex(d1,i2);
                return true;
            };
            return false;
        }

    }
}