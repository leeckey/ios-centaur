package centaur.manager
{
	import centaur.data.GlobalData;

	public final class PathManager
	{
		public function getConfigPath(name:String):String
		{
			return GlobalData.asite + "config/txt/" + name;
		}
		
		
	}
}