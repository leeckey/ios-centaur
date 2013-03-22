package ghostcat.display.graphics
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import ghostcat.display.GBase;
    import ghostcat.events.MoveEvent;
    import ghostcat.manager.DragManager;
    import ghostcat.parse.DisplayParse;
    import ghostcat.parse.display.RectParse;
    import ghostcat.parse.graphics.GraphicsClear;
    import ghostcat.parse.graphics.GraphicsFill;
    import ghostcat.parse.graphics.GraphicsLineStyle;
    import ghostcat.parse.graphics.GraphicsRect;
    import ghostcat.ui.CursorSprite;
    import ghostcat.util.display.DisplayUtil;

    /**
     * 图像变形控制器，点击自动选中，并可调整大小和旋转
     * 
     * @author flashyiyi
     * 
     */
    public class ControlRect extends GBase
    {
        /**
         * 选择的对象数组 
         */
        private static var selectedRects:Array = [];
        
        /**
         * 取消全部选择 
         * 
         */
        public static function unSelectAll():void
        {
            for (var i:int = selectedRects.length - 1;i>=0;i--)
            {
                var rect:ControlRect = selectedRects[i];
                rect.selected = false;
            }
            selectedRects = [];
        }
        
        /**
         * 容纳控制点的容器
         */
        public var controlCotainer:Sprite;
        /**
         * 线型
         */
        public var lineStyle:GraphicsLineStyle = new GraphicsLineStyle(0,0);
        /**
         * 填充
         */
        public var fill:GraphicsFill = new GraphicsFill(0xFFFFFF,0.5);
        
        public var fillControl:GBase;
        public var topLeftControl:DragPoint;
        public var topRightControl:DragPoint;
        public var bottomLeftControl:DragPoint;
        public var bottomRightControl:DragPoint;
        public var topLineControl:DragPoint;
        public var bottomLineControl:DragPoint;
        public var leftLineControl:DragPoint;
        public var rightLineControl:DragPoint;
        
        private var _lockX:Boolean = false;

        public function get lockX():Boolean
        {
            return _lockX;
        }

        public function set lockX(value:Boolean):void
        {
            _lockX = value;
            leftLineControl.visible = rightLineControl.visible = !value;
        }

        private var _lockY:Boolean = false;

        public function get lockY():Boolean
        {
            return _lockY;
        }

        public function set lockY(value:Boolean):void
        {
            _lockY = value;
            topLineControl.visible = bottomLineControl.visible = !value;
        }

        private var _lockRotation:Boolean = false;

        public function get lockRotation():Boolean
        {
            return _lockRotation;
        }

        public function set lockRotation(value:Boolean):void
        {
            _lockRotation = value;
            topLeftControl.visible = topRightControl.visible = bottomLeftControl.visible = bottomRightControl.visible = !value
        }

        
        public function ControlRect(skin:*=null,pointSkin:* = null,replace:Boolean=true)
        {
            createControl(pointSkin);
            
            super(skin,replace);
        }
        
        /** @inheritDoc*/
        protected override function init() : void
        {
            super.init();
            this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
        }
        
        /** @inheritDoc*/
        public override function set selected(v:Boolean):void
        {
            super.selected = v;
            
            var index:int;
            index = selectedRects.indexOf(this);
            if (v)
            {
                if (index == -1)
                    selectedRects.push(this);
            }
            else
            {
                if (index != -1)
                    selectedRects.splice(index,1);
            }
            this.controlCotainer.visible = v;
        }
        /** @inheritDoc*/
        override public function setContent(skin:*, replace:Boolean=true) : void
        {
            super.setContent(skin,replace);
            updateControls();
        }
            
        /**
         * 创建控制点
         * @param pointSkin
         * 
         */
        protected function createControl(pointSkin:*):void
        {
            controlCotainer = new Sprite();
            addChild(controlCotainer);
            controlCotainer.visible = false;
            
            fillControl = new GBase();
            fillControl.cursor = CursorSprite.CURSOR_DRAG;
            fillControl.addEventListener(MouseEvent.MOUSE_DOWN,fillMouseDownHandler,false,0,true);
            controlCotainer.addChild(fillControl);
            
            topLeftControl = new DragPoint(pointSkin);
            topLeftControl.cursor = CursorSprite.CURSOR_ROTATE_TOPLEFT;
            topLeftControl.addEventListener(MoveEvent.MOVE,topLeftControlHandler,false,0,true);
            topLeftControl.delayUpatePosition = true;
            controlCotainer.addChild(topLeftControl);
            
            topRightControl = new DragPoint(pointSkin);    
            topRightControl.cursor = CursorSprite.CURSOR_ROTATE_TOPRIGHT;
            topRightControl.addEventListener(MoveEvent.MOVE,topRightControlHandler,false,0,true);
            topRightControl.delayUpatePosition = true;
            controlCotainer.addChild(topRightControl);
            
            bottomLeftControl = new DragPoint(pointSkin);    
            bottomLeftControl.cursor = CursorSprite.CURSOR_ROTATE_BOTTOMLEFT;
            bottomLeftControl.addEventListener(MoveEvent.MOVE,bottomLeftControlHandler,false,0,true);
            bottomLeftControl.delayUpatePosition = true;
            controlCotainer.addChild(bottomLeftControl);
            
            bottomRightControl = new DragPoint(pointSkin);    
            bottomRightControl.cursor = CursorSprite.CURSOR_ROTATE_BOTTOMRIGHT;
            bottomRightControl.addEventListener(MoveEvent.MOVE,bottomRightControlHandler,false,0,true);
            bottomRightControl.delayUpatePosition = true;
            controlCotainer.addChild(bottomRightControl);
            
            topLineControl = new DragPoint(pointSkin);    
            topLineControl.cursor = CursorSprite.CURSOR_V_DRAG;
            topLineControl.lockX = true;
            topLineControl.addEventListener(MoveEvent.MOVE,topLineControlHandler,false,0,true);
            controlCotainer.addChild(topLineControl);
            
            bottomLineControl = new DragPoint(pointSkin);    
            bottomLineControl.cursor = CursorSprite.CURSOR_V_DRAG;
            bottomLineControl.lockX = true;
            bottomLineControl.addEventListener(MoveEvent.MOVE,bottomLineControlHandler,false,0,true);
            controlCotainer.addChild(bottomLineControl);
            
            leftLineControl = new DragPoint(pointSkin);    
            leftLineControl.cursor = CursorSprite.CURSOR_H_DRAG;
            leftLineControl.lockY = true;
            leftLineControl.addEventListener(MoveEvent.MOVE,leftLineControlHandler,false,0,true);
            controlCotainer.addChild(leftLineControl);
            
            rightLineControl = new DragPoint(pointSkin);    
            rightLineControl.cursor = CursorSprite.CURSOR_H_DRAG;
            rightLineControl.lockY = true;
            rightLineControl.addEventListener(MoveEvent.MOVE,rightLineControlHandler,false,0,true);
            controlCotainer.addChild(rightLineControl);
        }
        
        /**
         * 更新控制点
         * 
         */
        public function updateControls():void
        {
            DisplayUtil.moveToHigh(controlCotainer);
            
            var rect:Rectangle = content.getBounds(this);
            
            new RectParse(new GraphicsRect(rect.x,rect.y,rect.width,rect.height),lineStyle,fill,null,true).parse(fillControl);
            
            topLeftControl.setPosition(new Point(rect.x,rect.y),true);
            topRightControl.setPosition(new Point(rect.right,rect.y),true);
            bottomLeftControl.setPosition(new Point(rect.x,rect.bottom),true);
            bottomRightControl.setPosition(new Point(rect.right,rect.bottom),true);
            topLineControl.setPosition(new Point(rect.x + rect.width/2,rect.y),true);
            bottomLineControl.setPosition(new Point(rect.x + rect.width/2,rect.bottom),true);
            leftLineControl.setPosition(new Point(rect.x,rect.y + rect.height/2),true);
            rightLineControl.setPosition(new Point(rect.right,rect.y + rect.height/2),true);
        }
        
        private function topLeftControlHandler(event:MoveEvent):void
        {    
            if (!topLeftControl.mouseDown)
                return;
            
            var rect:Rectangle = content.getBounds(content);
            var baseRotate:Number = Math.atan2(rect.y,rect.x)/Math.PI * 180;
            this.rotation += Math.atan2(topLeftControl.position.y,topLeftControl.position.x)/Math.PI * 180 - baseRotate;
            updateControls();
        }
        
        private function topRightControlHandler(event:MoveEvent):void
        {
            if (!topRightControl.mouseDown)
                return;
            
            var rect:Rectangle = content.getBounds(content);
            var baseRotate:Number = Math.atan2(rect.y,rect.right)/Math.PI * 180;
            this.rotation += Math.atan2(topRightControl.position.y,topRightControl.position.x)/Math.PI * 180 - baseRotate;
            updateControls();
        }
        
        private function bottomLeftControlHandler(event:MoveEvent):void
        {
            if (!bottomLeftControl.mouseDown)
                return;
            
            var rect:Rectangle = content.getBounds(content);
            var baseRotate:Number = Math.atan2(rect.bottom,rect.x)/Math.PI * 180;
            this.rotation += Math.atan2(bottomLeftControl.position.y,bottomLeftControl.position.x)/Math.PI * 180 - baseRotate;
            updateControls();
        }
        
        private function bottomRightControlHandler(event:MoveEvent):void
        {
            if (!bottomRightControl.mouseDown)
                return;
            
            var rect:Rectangle = content.getBounds(content);
            var baseRotate:Number = Math.atan2(rect.bottom,rect.right)/Math.PI * 180;
            this.rotation += Math.atan2(bottomRightControl.position.y,bottomRightControl.position.x)/Math.PI * 180 - baseRotate;
            updateControls();
        }
        
        private function topLineControlHandler(event:MoveEvent):void
        {
            if (!topLineControl.mouseDown)
                return;
            
            var rect:Rectangle = content.getBounds(content);
            var dy:Number = topLineControl.position.y - rect.y;
            y = y + dy;
            content.height -= dy;
            
            updateControls();
        }
        
        private function bottomLineControlHandler(event:MoveEvent):void
        {
            if (!bottomLineControl.mouseDown)
                return;
            
            var rect:Rectangle = content.getBounds(this);
            var dy:Number = bottomLineControl.position.y - rect.bottom;
//            y = y + dy;
            content.height += dy;
            
            updateControls();
        }
        
        private function leftLineControlHandler(event:MoveEvent):void
        {
            if (!leftLineControl.mouseDown)
                return;
            
            var rect:Rectangle = content.getBounds(content);
            var dx:Number = leftLineControl.position.x - rect.x;
            x = x + dx;
            content.width -= dx;
            
            updateControls();
        }
        
        private function rightLineControlHandler(event:MoveEvent):void
        {
            if (!rightLineControl.mouseDown)
                return;
            
            var rect:Rectangle = content.getBounds(this);
            var dx:Number = rightLineControl.position.x - rect.right;
//            x = x + dx;
            content.width += dx;
            
            updateControls();
        }
        
        private function fillMouseDownHandler(event:MouseEvent):void
        {
            for each (var rect:ControlRect in selectedRects)
            {
                DragManager.startDrag(rect);
            }
        }
        
        private function mouseDownHandler(event:MouseEvent):void
        {
            if (selected)
                return;
            
            if (!event.shiftKey)
                unSelectAll();
            
            selected = true;
            
            fillMouseDownHandler(event);
        }
        
        private function mouseUpHandler(event:MouseEvent):void
        {
            
        }
        /** @inheritDoc*/
        override public function destory():void
        {
            this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
            
            super.destory();
        }
    }
}