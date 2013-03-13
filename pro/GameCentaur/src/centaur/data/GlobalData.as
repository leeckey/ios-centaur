package centaur.data
{
	public final class GlobalData
	{
		public static var GAME_WIDTH:int = 960;
		public static var GAME_HEIGHT:int = 640;
		
		public static function onGameResize(stageWidth:int, stageHeight:int):void
		{
			GAME_WIDTH = stageWidth;
			GAME_HEIGHT = stageHeight;
			
			
		}
	}
}