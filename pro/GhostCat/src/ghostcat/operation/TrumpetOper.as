package ghostcat.operation
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.geom.Point;
    
    import ghostcat.ui.TrumpetManager;

    /**
     *  小喇叭操作 
     */
    public class TrumpetOper extends Oper
    {
        public var obj:DisplayObject;
        public var owner:DisplayObject;
        public var centerMode:String;
        public var offest:Point;
        
        public function TrumpetOper(obj:DisplayObject, owner:DisplayObject, centerMode:String, offest:Point)
        {
            super();
            
            this.obj = obj;
            this.owner = owner;
            this.centerMode = centerMode;
            this.offest = offest;
        }
        
        /** @inheritDoc*/
        override public function execute():void
        {
            super.execute();
            
            show();
            obj.addEventListener(Event.REMOVED_FROM_STAGE, result);
        }
        
        protected function show():void
        {
            TrumpetManager.instance.showText(obj, owner, centerMode, offest);
        }
        
        /** @inheritDoc*/
        protected override function end(event:* = null) : void
        {
            super.end(event);
            obj.removeEventListener(Event.REMOVED_FROM_STAGE,result);
        }
    }
}