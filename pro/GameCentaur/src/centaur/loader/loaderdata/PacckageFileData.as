package centaur.loader.loaderdata
{
    import flash.display.*;

	/**
	 *   动画帧数据,指定相应图片以及偏移位置
	 */ 
    public class PacckageFileData extends Object
    {
        public var data:BitmapData;
        public var x:Number;
        public var y:Number;
		
		public var _blendMode:String;
		
        public function PacckageFileData(bd:BitmapData, x:Number, y:Number)
        {
            this.data = bd;
            this.x = x;
            this.y = y;
        }
		
        public function dispose() : void
        {
            if (this.data)
            {
                this.data.dispose();
            }
            this.data = null;
        }

    }
}
