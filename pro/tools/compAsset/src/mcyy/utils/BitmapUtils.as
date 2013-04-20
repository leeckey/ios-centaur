package mcyy.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import helper.SWFWriterHelper;
	
	import mcyy.loader.fanim.FanmFileInfo;
	
	import mx.graphics.codec.JPEGEncoder;

	public final class BitmapUtils
	{
		public static function addImageAssets(bmp:BitmapData,quality:int = 80):Object
		{
			var jpg:JPEGEncoder = new JPEGEncoder(quality);
			return {alphaData:getAlphapixels(bmp.getPixels(bmp.rect)),jpegData: jpg.encode(bmp)};
		}
		
		public static function getAlphapixels(pixels:ByteArray):ByteArray{
			var data1:ByteArray = new ByteArray;
			var i:int = 0;
			while(i< pixels.length){
				var alpha:int = (pixels[i]) ; 
				data1.writeByte(alpha); 
				i = i+4;
			}
			data1.compress();
			return data1;
		}
		
		public static function handleBitmapData(bitmapData:BitmapData, clip:Boolean, cX:int, cY:int):Object
		{
			// 如果选择不裁剪，直接返回原图数据
			if (!clip)
			{
				return {cx: int(cX), cy: int(cY), rw:bitmapData.width, rh:bitmapData.height, bitmapData: bitmapData};
			}
			
			var x_min:int=bitmapData.width;
			var x_max:int=0;
			var y_min:int=bitmapData.height;
			var y_max:int=0;
			
			var value:uint = 0;
			for(var j:int=0; j<bitmapData.height; j++)
			{
				var temp:int = 0;
				for(var i:int=0; i<bitmapData.width; i++)
				{
					value = bitmapData.getPixel32(i, j);
					if(value>0)
					{
						if(i<x_min){
							x_min = i;
						}
						else if(i>x_max){
							x_max = i;
						}
						if(j<y_min){
							y_min = j;
						}
						else if(j>y_max){
							y_max = j;
						}
					}
				}
			}
			var cx:int = int(cX) - x_min;
			var cy:int = int(cY) - y_min;
			
			var rw:int = x_max - x_min+1;
			var rh:int = y_max - y_min+1;
			if(rw<0 || rh<0){
				rw = 10;
				rh = 10;
				x_min = 0;
				y_min = 0;
			}
			
			var newBitmapData:BitmapData = new BitmapData(rw, rh);
			newBitmapData.copyPixels(bitmapData, new Rectangle(x_min, y_min, rw, rh), new Point(0,0));
			
			return {cx: cx, cy: cy, rw:rw, rh:rh, bitmapData: newBitmapData};
		}
		
		public static function FamToSWFBytes(pF:FanmFileInfo):ByteArray
		{
			if (!pF || (pF.count == 0))
				return null;
			
			if (pF.swfBytes && pF.swfBytes.length > 0)
				return pF.swfBytes;
			
			var swfHelper:SWFWriterHelper = new SWFWriterHelper();
			for (var i:int = 0; i < pF.count; ++i)
			{
				var frmObject:Object = pF.bitmapDatas[i];
				var jpegData:ByteArray = (frmObject is ByteArray) ? frmObject as ByteArray : frmObject.jpegData;
				var alphaData:ByteArray = (frmObject is ByteArray) ? null : frmObject.alphaData;
				
				swfHelper.addBitmapAssets(jpegData, alphaData, pF.generateClassName(i), i + 10000);
			}
			
			return swfHelper.toBytes();
		}
	}
}