package ghostcat.ui.tooltip
{
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import ghostcat.skin.ArowSkin;
    import ghostcat.ui.ToolTipSprite;
    import ghostcat.ui.controls.GText;
    import ghostcat.ui.layout.Padding;
    import ghostcat.util.core.ClassFactory;
    import ghostcat.util.display.Geom;
    import ghostcat.util.easing.TweenUtil;
    
    /**
     * IToolTipSkin的默认实现
     * 
     * @author flashyiyi
     * 
     */
    public class ToolTipSkin extends GText implements IToolTipSkin
    {
        public static var defaultSkin:ClassFactory = new ClassFactory(ArowSkin);
        
        public function ToolTipSkin(skin:*=null)
        {
            if (!skin)
                skin = defaultSkin;
                
            super(skin);
        
            this.enabledAutoLayout(new Padding(2,2,2,2));
        }
        
        /** @inheritDoc*/
        public function show(target:DisplayObject):void
        {
//            var toolTipSprite:ToolTipSprite = this.parent as ToolTipSprite;
//            toolTipSprite.x = toolTipSprite.parent.mouseX + 10;
//            toolTipSprite.y = toolTipSprite.parent.mouseY + 10;
//            toolTipSprite.blendMode = BlendMode.LAYER;
//            
//            TweenUtil.removeTween(toolTipSprite);
//            TweenUtil.from(toolTipSprite,100,{alpha:0.0,y:"10"}).update();
        }
        
        /** @inheritDoc*/
        public function positionTo(target:DisplayObject):void
        {
            TweenUtil.removeTween(toolTipSprite);
            var toolTipSprite:ToolTipSprite = this.parent as ToolTipSprite;
//            toolTipSprite.x = toolTipSprite.parent.mouseX + 10;
//            toolTipSprite.y = toolTipSprite.parent.mouseY + 10;
            
            var targetGlobal:Point = Geom.localToContent(new Point(), target, toolTipSprite.parent);
            var targetPos:Point = calcAvaiablePosition(new Point(toolTipSprite.parent.width, toolTipSprite.parent.height), 
                                                        new Rectangle(targetGlobal.x, targetGlobal.y, target.width, target.height), 
                                                        new Point(toolTipSprite.width, toolTipSprite.height));
            
            toolTipSprite.x = targetPos.x;
            toolTipSprite.y = targetPos.y;
        }
        
        protected function calcAvaiablePosition(parentSize:Point, targetRect:Rectangle, tooltipSize:Point, margin:int = 10):Point
        {
            var x:int;
            var y:int;
            
            // 右侧能容下
            if (targetRect.x + targetRect.width +  tooltipSize.x + margin < parentSize.x)
                x = targetRect.x + targetRect.width + margin;
            else
                x = targetRect.x - tooltipSize.x - margin;
            
            // 下侧能容下
            if (targetRect.y + targetRect.height + tooltipSize.y + margin < parentSize.y)
                y = targetRect.y + targetRect.height + margin;
            else if (targetRect.y + targetRect.height * 0.5 + tooltipSize.y * 0.5 + margin < parentSize.y)
                y = targetRect.y + targetRect.height * 0.5 - tooltipSize.y * 0.5;
            else
                y = targetRect.y - tooltipSize.y;
            
            return new Point(x, y);
        }
    }
}