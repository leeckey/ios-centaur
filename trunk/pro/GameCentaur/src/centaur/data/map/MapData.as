package centaur.data.map
{
	import centaur.utils.Utils;
	
	import flash.geom.Point;

	/**
	 *   地图数据
	 */ 
	public final class MapData
	{
		public var templateID:uint;		// 模板ID	
		public var name:String;			// 名称
		public var backPicID:uint;		// 背景资源
		
		public var insMapList:Array = Utils.EMPTY_ARRAY;	// 地图中的推图目标ID列表
		public var insPosList:Array = Utils.EMPTY_ARRAY;	// 目标显示位置列表
		
		public function MapData()
		{
		}
		
		public function init():void
		{
			var len:int = insPosList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var str:String = insPosList[i];
				var strArr:Array = str.split("_");
				if (strArr.length == 2)
				{
					var point:Point = new Point(strArr[0], strArr[1]);
					insPosList[i] = point;
				}
				else
					insPosList[i] = null;
			}
		}
	}
}