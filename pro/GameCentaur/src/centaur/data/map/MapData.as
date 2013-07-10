package centaur.data.map
{
	import centaur.utils.Utils;

	/**
	 *   地图数据
	 */ 
	public final class MapData
	{
		public var templateID:uint;		// 模板ID	
		public var name:String;			// 名称
		public var backPicID:uint;		// 背景资源
		
		public var insMapList:Array = Utils.EMPTY_ARRAY;	// 地图中的推图目标ID列表
		public var insPosList:Array;	// 目标显示位置列表
		
		public function MapData()
		{
		}
		
		public function init():void
		{
			
		}
	}
}