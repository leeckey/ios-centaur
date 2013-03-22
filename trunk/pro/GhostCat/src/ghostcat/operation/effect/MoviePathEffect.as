package ghostcat.operation.effect
{
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    
    import ghostcat.display.movieclip.GMovieClip;
    import ghostcat.events.MovieEvent;
    import ghostcat.events.TickEvent;
    import ghostcat.operation.Oper;
    import ghostcat.util.Tick;
    
    public class MoviePathEffect extends Oper implements IEffect
    {
        private var _target:*;
        
        public function get target():*
        {
            return _target;
        }
        
        public function set target(v:*):void
        {
            _target = v;
        }
        
        public var path:*;
        public var duration:Number;
        
        private var gmovie:GMovieClip;
        
        public function MoviePathEffect(target:DisplayObject=null, path:*=null, duration:Number = NaN)
        {
            this.target = target;
            this.path = path;
            this.duration = duration;
            super();
        }
        
        public override function execute() : void
        {
            super.execute();
            
            if (gmovie)
                gmovie.destory();
            
            gmovie = new GMovieClip(path);
            gmovie.setLoop(1);
            gmovie.addEventListener(MovieEvent.MOVIE_END,result);
            
            if (duration)
                gmovie.frameRate = gmovie.totalFrames / duration * 1000;
            
            Tick.instance.addTickHandler(tickHandler);
            tickHandler(null);
        }
        
        protected override function end(event:*=null) : void
        {
            super.end(event);
            
            Tick.instance.removeTickHandler(tickHandler);
            tickHandler(null);
        }
        
        protected function tickHandler(event:TickEvent):void
        {
            var s:DisplayObject = (gmovie.content as MovieClip).getChildAt(0);
            target.transform.matrix = s.transform.matrix.clone();
        }
    }
}