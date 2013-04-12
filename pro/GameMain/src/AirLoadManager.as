package
{
	import centaur.loader.LoaderManager;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public final class AirLoadManager extends LoaderManager
	{
		public function AirLoadManager()
		{
		}
		
		
		
		override public function loadGBKString(path:String):String
		{
			var file:File = File.applicationDirectory.resolvePath(path);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, "gbk");
			fileStream.close();
			
			return str;
		}
		
		override public function loadByteArray(path:String):ByteArray
		{
			var file:File = File.applicationDirectory.resolvePath(path);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes(bytes);
			fileStream.close();
			
			return bytes;
		}
	}
}