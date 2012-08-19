package centaur.utils
{
	public final class UniqueNameFactory
	{
		private static var _count:int;
		
		public static function getUniqueName(suffix:String = null):String
		{
			if (!suffix)
				suffix = "suffix";
			return suffix + (_count++);
		}
	}
}