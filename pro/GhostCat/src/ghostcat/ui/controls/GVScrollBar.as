package ghostcat.ui.controls
{
    import ghostcat.ui.UIConst;
    import ghostcat.util.core.ClassFactory;
    
    /**
     * 纵向滚动条
     *  
     * @author flashyiyi
     * 
     */
    public class GVScrollBar extends GScrollBar
    {
        public static var defaultSkin:* = null/*VScrollBarSkin*/;
        
        public function GVScrollBar(skin:*=null, replace:Boolean=true)
        {
            if (!skin)
                skin = defaultSkin;
            
            super(skin, replace);
            
            this.direction = UIConst.VERTICAL;
        }
    }
}