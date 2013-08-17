package centaur.manager
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;

	public final class PathManager
	{
		public function getConfigPath(name:String):String
		{
			return GlobalData.asite + "assets/config/txt/" + name;
		}
		
		public function getCardHeadByID(id:uint):String
		{
			return GlobalData.asite + "assets/ui/Head/" + id + ".jpg";
		}
		
		public function getCardBodyByID(id:uint):String
		{
			return GlobalData.asite + "assets/ui/Card/" + id + ".png";
		}
		
		public function getRoundActionEffectPath():String
		{
			return GlobalData.asite + "assets/effects/huihexg.fam";
		}
		
		public function getMapBackgroundPath(mapID:uint):String
		{
			return GlobalData.asite + "assets/ui/map/" + mapID + "/back.png";	
		}
		
		public function getMapItemBackPath():String
		{
			return GlobalData.asite + "assets/ui/map/mapbtn.png";	
		}
		
		public function getMapItemPath(mapID:uint, itemIdx:uint):String
		{
			return GlobalData.asite + "assets/ui/map/" + mapID + "/item" + itemIdx + ".png";
		}
		
		public function getMapItemNamePath(mapID:uint, itemIdx:uint):String
		{
			return GlobalData.asite + "assets/ui/map/" + mapID + "/itemname" + itemIdx + ".png";
		}
	}
}