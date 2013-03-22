package ghostcat.ui
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import ghostcat.display.GBase;
    import ghostcat.operation.PopupOper;
    import ghostcat.operation.Queue;
    import ghostcat.operation.TrumpetOper;
    import ghostcat.ui.controls.GText;
    import ghostcat.util.core.Singleton;
    import ghostcat.util.display.Geom;

    /**
     *   小喇叭管理类
     */
    public class TrumpetManager extends Singleton
    {
        public static function get instance():TrumpetManager
        {
            return Singleton.getInstanceOrCreate(TrumpetManager) as TrumpetManager;
        }
        
        /**
         * 显示一个临时的背景遮罩在对象后面作为遮挡，并会和对象一起被删除
         * 
         * @param v - 目标
         * @param color    - 颜色
         * @param alpha    - 透明度
         * @param mouseEnabled    - 是否遮挡下面的鼠标事件
         * 
         */
        static public function createTempCover(v:DisplayObject,color:uint = 0x0,alpha:Number = 0.5,mouseEnabled:Boolean = false):void
        {
            var parent:DisplayObjectContainer = v.parent;
            //背景遮罩
            var back:Sprite = new Sprite();
            var rect:Rectangle = Geom.localRectToContent(new Rectangle(0,0,parent.stage.stageWidth,parent.stage.stageHeight),parent.stage,parent);
            back.graphics.beginFill(color,alpha);
            back.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
            back.graphics.endFill();
            back.mouseEnabled = mouseEnabled;
            parent.addChildAt(back,parent.getChildIndex(v));
            
            v.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
            function removeHandler(event:Event):void
            {
                parent.removeEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
                parent.removeChild(back);    
            }
        }
        
        private var _trumpetLayer:DisplayObjectContainer;
        private var _application:DisplayObjectContainer;
        
        /**
         * 小喇叭指定的队列，为空则为全局队列
         */
        public var queue:Queue = null;
        
        /**
         * 是否在addChild子窗口后设置坐标
         */
        public var setPositionAfterAdd:Boolean;
        
        public function TrumpetManager()
        {
            
        }
        
        /**
         *   小喇叭容器 
         */
        public function get trumpetLayer():DisplayObjectContainer
        {
            return _trumpetLayer;
        }
        
        public function set trumpetLayer(value:DisplayObjectContainer):void
        {
            _trumpetLayer = value;
        }
        
        /**
         * 主程序（模态弹出时将被禁用） 
         * @return 
         * 
         */
        public function get application():DisplayObjectContainer
        {
            return _application;
        }
        
        public function set application(v:DisplayObjectContainer):void
        {
            _application = v;
        }
        
        /**
         * 注册使用此层
         */
        public function register(application:DisplayObjectContainer,trumpetLayer:DisplayObjectContainer):void
        {
            this.application = application;
            this.trumpetLayer = trumpetLayer;
        }
        
        /**
         *  队列显示GText中的text 
         */
        public function queuePopup(obj:DisplayObject, owner:DisplayObject=null, centerMode:String = "rect", offest:Point = null):DisplayObject
        {
            var oper:TrumpetOper = new TrumpetOper(obj, owner, centerMode,offest);
            
            if (!queue)
                queue = this.queue;
            
            oper.commit(queue);
            
            return obj;
        }
        
        /**
         *   显示TrumpetUI
         */
        public function showText(obj:DisplayObject, owner:DisplayObject=null, centerMode:String = "rect", offest:Point = null):DisplayObject
        {
            if (setPositionAfterAdd)
                trumpetLayer.addChild(obj);
            
            if (centerMode == CenterMode.RECT)
            {
                Geom.centerIn(obj,trumpetLayer.stage);
            }
            else if (centerMode == CenterMode.POINT)
            {
                var center:Point = trumpetLayer.globalToLocal(Geom.center(trumpetLayer.stage));
                obj.x = center.x;
                obj.y = center.y;
            }
            
            if (offest)
            {
                obj.x += offest.x;
                obj.y += offest.y;
            }
            
            if (!setPositionAfterAdd)
                trumpetLayer.addChild(obj);
            
            if (owner && obj is GBase)
                (obj as GBase).owner = owner;
            
            return obj;
        }
        
        /**
         * 销毁一个GText
         * @param obj
         * 
         */
        public function removeText(obj:DisplayObject, autoDestory:Boolean = true):void
        {
            if (obj.parent == trumpetLayer)
            {
                if (autoDestory && (obj is GBase))
                    (obj as GBase).destory();
                else
                    trumpetLayer.removeChild(obj);
            }
        }
        
        /**
         *  销毁所有的GText中的text信息 
         */
        public function removeAllText(autoDestory:Boolean = true):void
        {
            while (trumpetLayer.numChildren)
            {
                removeText(trumpetLayer.getChildAt(0), autoDestory);
            }
        }
    }
}