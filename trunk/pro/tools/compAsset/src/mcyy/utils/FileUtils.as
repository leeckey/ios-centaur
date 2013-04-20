package mcyy.utils
{
	import flash.filesystem.File;

	public final class FileUtils
	{
		/**
		 *   找出文件夹下面所有的指定格式文件
		 */ 
		public static function getAllSpecificFiles(file:File, list:Array, specificStr:String = ".fam"):void
		{
			if (file.nativePath.indexOf(".svn") > -1)
				return;
			
			if (!file.isDirectory)
			{
				if (file.nativePath.indexOf(specificStr) > -1)
					list.push(file);
			}
			else
			{
				// 递归所有目录
				var childList:Array = file.getDirectoryListing();
				var length:int = childList.length;
				for (var i:int = 0; i < length; ++i)
				{
					getAllSpecificFiles(childList[i] as File, list, specificStr);
				}
			}
		}
		
		/**
		 *   找出包含指定格式文件的所有文件夹
		 */ 
		public static function getAllSpecificFilesParentDirectory(file:File, list:Array, specificStr:String = ".fam"):void
		{
			if (file.nativePath.indexOf(".svn") > -1)
				return;
			
			if (!file.isDirectory)
			{
				if (file.nativePath.indexOf(specificStr) > -1)
				{
					var parentFilePath:String = file.parent.nativePath;
					if (list.indexOf(parentFilePath) == -1)
						list.push(parentFilePath);
				}
			}
			else
			{
				// 递归所有目录
				var childList:Array = file.getDirectoryListing();
				var length:int = childList.length;
				for (var i:int = 0; i < length; ++i)
				{
					getAllSpecificFilesParentDirectory(childList[i] as File, list, specificStr);
				}
			}
		}
	}
}