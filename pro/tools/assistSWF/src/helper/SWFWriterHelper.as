package helper
{
	import flash.utils.ByteArray;
	
	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.io.AbcSerializer;
	import org.libspark.swfassist.io.ByteArrayOutputStream;
	import org.libspark.swfassist.swf.io.SWFWriter;
	import org.libspark.swfassist.swf.io.WritingContext;
	import org.libspark.swfassist.swf.structures.Asset;
	import org.libspark.swfassist.swf.structures.SWF;
	import org.libspark.swfassist.swf.tags.DefineBitsJPEG3;
	import org.libspark.swfassist.swf.tags.DoABC;
	import org.libspark.swfassist.swf.tags.ShowFrame;
	import org.libspark.swfassist.swf.tags.SymbolClass;

	public final class SWFWriterHelper
	{
		private var _swf:SWF;
		private var _symbolClass:SymbolClass;
		
		private var _abcFile:AbcFile;
		private var _abcBuilder:AbcBuilder;
		
		public function SWFWriterHelper()
		{
			_swf = Utils.createSWF();
			_symbolClass = new SymbolClass();
			
			_abcFile = new AbcFile();
			_abcBuilder = new AbcBuilder(_abcFile);
		}
		
		public function addBitmapAssets(imageBytes:ByteArray, alphaBytes:ByteArray, className:String, seq:int):void
		{
			var tag:DefineBitsJPEG3 = new DefineBitsJPEG3();
			tag.bitmapAlphaData = alphaBytes;
			tag.jpegData = imageBytes;
			tag.characterId = seq;
			_swf.tags.addTag(tag);
			
			// 保存类名资源
			var asset:Asset = new Asset();
			asset.characterId = seq;
			asset.name = className;
			_symbolClass.symbols.push(asset);
			
			// 生成代码的abc码
			this.addClassToABCBytes(className, "flash.display.BitmapData", 2, 2);
		}
		
		public function toBytes():ByteArray
		{
			var id:int = 10001;
			
			var abc:DoABC = new DoABC;
			abc.isLazyInitialize = true;
			abc.abcData = createABCBytes();
			_swf.tags.addTag(abc);
			
			if (_symbolClass)
				_swf.tags.addTag(_symbolClass);
			
			_swf.tags.addTag(new ShowFrame());
			_swf.header.numFrames++;
			
			var data:ByteArray = new ByteArray();
			var swfWrriter:SWFWriter = new SWFWriter();
			var out:ByteArrayOutputStream = new ByteArrayOutputStream(data);
			var context:WritingContext = new WritingContext();
			swfWrriter.writeSWF(out,context,_swf);
			
			return data;
		}
		
		public function write(filePath:String):void
		{
			
		}
		
		private function addClassToABCBytes(classFullName:String, superClassName:String, width:int, height:int):void
		{
			var classBuilder:IClassBuilder = _abcBuilder.defineClass(classFullName, superClassName);
			classBuilder.isDynamic = true;
			var icorBuilder:ICtorBuilder = classBuilder.defineConstructor();
			icorBuilder.defineArgument("int", true, width);
			icorBuilder.defineArgument("int", true, height);
			icorBuilder.addOpcode(Opcode.getlocal_0)					
				.addOpcode(Opcode.pushscope)					
				.addOpcode(Opcode.getlocal_0)					
				.addOpcode(Opcode.getlocal_1)					
				.addOpcode(Opcode.getlocal_2)					
				.addOpcode(Opcode.constructsuper, [2])					
				.addOpcode(Opcode.returnvoid);
		}
		
		private function createABCBytes():ByteArray
		{
			var result:AbcFile = _abcBuilder.build();
			var bytes:ByteArray = new AbcSerializer().serializeAbcFile(result);
			
			var newBytes:ByteArray = new ByteArray();
			newBytes.writeByte(0);
			newBytes.writeBytes(bytes, 0, bytes.length);
			return newBytes;
		}
	}
}