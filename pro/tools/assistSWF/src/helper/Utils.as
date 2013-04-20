package helper
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	
	import org.libspark.swfassist.swf.structures.SWF;
	import org.libspark.swfassist.swf.structures.SceneData;
	import org.libspark.swfassist.swf.tags.*;

	public class Utils
	{
		public function Utils()
		{
		}
		
		public static function createSWF():SWF
		{
			var swf:SWF = new SWF();
			swf.header.version = 9;
			swf.header.frameSize.xMax = 2;
			swf.header.frameSize.yMax = 2;
			swf.header.frameRate = 24;
			swf.header.numFrames = 0;
			swf.header.isCompressed = true;////----wangq
			
			var fileAtt:FileAttributes = new FileAttributes;
			fileAtt.isActionScript3 = true;
			fileAtt.hasMetadata = true; 
			fileAtt.useNetwork = true;  
			swf.fileAttributes = fileAtt;
			var bgColor:SetBackgroundColor = new SetBackgroundColor();
			bgColor.backgroundColor.fromUint(0xffffff);
			swf.tags.addTag(bgColor);
			
			var sceneAndFrameLabelData:DefineSceneAndFrameLabelData = new DefineSceneAndFrameLabelData;
			var sceneData:SceneData = new SceneData;
			sceneData.name = "场景 1";
			sceneAndFrameLabelData.scenes.push(sceneData);
			swf.tags.addTag(sceneAndFrameLabelData);
			
			return swf;
		}
		
		
		public static function addImageAssets(swf:SWF,id:int,bmp:BitmapData,quality:int = 80):void
		{
			var jpg:JPEGEncoder = new JPEGEncoder(quality);
			var tag:DefineBitsJPEG3 = new DefineBitsJPEG3();
			tag.bitmapAlphaData = getAlphapixels(bmp.getPixels(bmp.rect));
			tag.jpegData = jpg.encode(bmp);
			tag.characterId = id;////----wangq (id * 2) + 1;
			
			swf.tags.addTag(tag);
			
			////----wangq
			
//			var placeObj:PlaceObject3 = new PlaceObject3;
////			placeObj.className = "bitmap" + id;
//			placeObj.name = "bitmap" + id;
//			placeObj.characterId = (id * 2) + 1;
////			placeObj.hasClassName = true;
//			placeObj.hasCharacter = true;
//			placeObj.depth = id + 1;
////			placeObj.hasImage = true;
//			swf.tags.addTag(placeObj);
//			var placeObject:PlaceObject2 = new PlaceObject2();
//			placeObject.characterId = (id * 2 + 1) + 1;
//			placeObject.depth = id + 1;
//			placeObject.hasCharacter = true;
//			swf.tags.addTag(placeObject);
//			swf.tags.addTag(new ShowFrame());
//			swf.header.numFrames++;
		}
		
		public static function addTextAssets(swf:SWF,characterId:int, value:String):int
		{
			var tagDS:DefineSprite = new DefineSprite();
			tagDS.spriteId = characterId+1;
			
			var tagPO:PlaceObject2 = new PlaceObject2();
			tagPO.name ="info";
			tagPO.hasCharacter = true;
			tagPO.hasMatrix = true;
			tagPO.depth=1;
			tagPO.characterId = characterId;
			
			var tagText:DefineEditText = new DefineEditText();
			tagText.leading = 0;
			tagText.indent = 0;
			tagText.wordWrap = true;
			tagText.readOnly =true;
			tagText.variableName = "info";
			tagText.initialText = value;
			tagText.wasStatic = false;
			tagText.characterId = characterId;
			tagText.hasText = true;
			tagText.fontHeight = 12;
			tagText.hasFont = true;
			tagText.fontClass ="Arial";
			tagText.autoSize = true;
			swf.tags.addTag(tagText);
			tagDS.tags.addTag(tagPO);
			swf.tags.addTag(tagDS);
			
			return tagDS.spriteId;
			
			
		}
		
		
		private static function getAlphapixels(pixels:ByteArray):ByteArray{
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
		
		
		
	}
}