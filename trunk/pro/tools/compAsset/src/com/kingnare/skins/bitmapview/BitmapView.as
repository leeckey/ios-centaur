package com.kingnare.skins.bitmapview
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 *   FANM文件中的位图视图，后续可能添加
	 *   @author wangq 2012.09.29
	 */ 
	public final class BitmapView extends Sprite
	{
		public static const WIDTH:int = 250;
		public static const HEIGHT:int = 150;
		
		// 显示位图
		private var _bitmap:Bitmap;
		
		public function BitmapView()
		{
			setup();
		}
		
		protected function setup():void
		{
			_bitmap = new Bitmap();
			addChild(_bitmap);
			
			var title:TextField = new TextField();
			title.text = "图像视窗";
			addChild(title);
			
			graphics.clear();
			graphics.lineStyle(1);
			graphics.drawRect(0, 0, WIDTH-1, HEIGHT-1);
			graphics.endFill();
			
			this.scrollRect = new Rectangle(0, 0, WIDTH, HEIGHT);
		}
		
		public function updateBitmapData(bitmapData:BitmapData):void
		{
			_bitmap.bitmapData = bitmapData;
			_bitmap.smoothing = true;
			_bitmap.scaleX = _bitmap.scaleY = 1;
			
			if (_bitmap.width > WIDTH)
				_bitmap.scaleX = WIDTH / _bitmap.width;
			if (_bitmap.height > HEIGHT)
				_bitmap.scaleY = HEIGHT / _bitmap.height;
			
			_bitmap.x = (WIDTH - _bitmap.width) * 0.5;
			_bitmap.y = (HEIGHT - _bitmap.height) * 0.5;
		}
	}
}