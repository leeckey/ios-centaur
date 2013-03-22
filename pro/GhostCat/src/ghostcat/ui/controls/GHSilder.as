package ghostcat.ui.controls
{
    import ghostcat.ui.UIConst;
    import ghostcat.util.core.ClassFactory;

    /**
     * 横向拖动块 
     * @author flashyiyi
     * 
     */
    public class GHSilder extends GSilder
    {
        public static var defaultSkin:* = null;/*HSilderSkin*/
        
        public function GHSilder(skin:* =null, replace:Boolean=true, fields:Object=null)
        {
            if (!skin)
                skin = defaultSkin;
            
            super(skin, replace, fields);
            
            this.direction = UIConst.HORIZONTAL;
        }
    }
}