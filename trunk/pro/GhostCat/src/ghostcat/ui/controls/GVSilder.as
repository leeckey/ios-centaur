package ghostcat.ui.controls
{
    import ghostcat.ui.UIConst;
    import ghostcat.util.core.ClassFactory;

    /**
     * 纵向拖动块 
     * @author flashyiyi
     * 
     */
    public class GVSilder extends GSilder
    {
        public static var defaultSkin:* = null;/*VSilderSkin*/
        
        public function GVSilder(skin:* =null, replace:Boolean=true, fields:Object=null)
        {
            if (!skin)
                skin = defaultSkin;
            
            super(skin, replace, fields);
            
            this.direction = UIConst.VERTICAL;
        }
    }
}