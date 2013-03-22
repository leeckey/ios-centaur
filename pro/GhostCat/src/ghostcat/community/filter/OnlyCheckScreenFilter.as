package ghostcat.community.filter
{
    import flash.display.DisplayObject;
    
    import ghostcat.util.display.DisplayUtil;

    /**
     * 过滤屏幕内物品
     * 
     * @author flashyiyi
     * 
     */
    public final class OnlyCheckScreenFilter
    {
        /**
         * 过滤屏幕内物品
         * 
         * @param o
         * @return 
         * 
         */
        public static function onlyCheckScreenHandler(o:DisplayObject):Boolean
        {
            return DisplayUtil.inScreen(o);
        }
    }
}