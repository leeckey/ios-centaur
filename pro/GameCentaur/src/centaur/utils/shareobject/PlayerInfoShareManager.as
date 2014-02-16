package centaur.utils.shareobject
{
	import centaur.data.GlobalData;
	import centaur.data.act.HeroData;
	import centaur.data.card.CardData;
	import centaur.data.player.PlayerInfo;
	import centaur.utils.GSaveManager;
	
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

	/**
	 *   主角信息本地存储类
	 */ 
	public final class PlayerInfoShareManager
	{
		public function PlayerInfoShareManager()
		{
		}
		
		public static function registerClass():void
		{
			registerClassAlias("PlayerInfo", PlayerInfo);
			registerClassAlias("HeroData", HeroData);
			registerClassAlias("CardData", CardData);
			
		}
		
		public static function saveSelf():void
		{
			PlayerInfoShareManager.setSharePlayerInfo(GlobalData.mainPlayerInfo);
			PlayerInfoShareManager.setShareHeroData(GlobalData.mainActData);
		}
		
		public static function getSharePlayerInfo(name:String = "mainInfo"):PlayerInfo
		{
			registerClass();
			var bytes:ByteArray = GSaveManager.instance.getData(name) as ByteArray;
			if (!bytes)
				return null;	
			
			bytes.position = 0;
			var info:PlayerInfo = bytes.readObject() as PlayerInfo;
			return info;
		}
		
		public static function setSharePlayerInfo(info:PlayerInfo, name:String = "mainInfo"):void
		{
			registerClass();
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(info);
			
			GSaveManager.instance.setData(bytes, name);
		}
		
		public static function getShareHeroData(name:String = "heroData"):HeroData
		{
			registerClass();
			var bytes:ByteArray = GSaveManager.instance.getData(name) as ByteArray;
			if (!bytes)
				return null;	
			
			bytes.position = 0;
			var data:HeroData = bytes.readObject() as HeroData;
			return data;
		}
		
		public static function setShareHeroData(data:HeroData, name:String = "heroData"):void
		{
			registerClass();
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(data);
			
			GSaveManager.instance.setData(bytes, name);
		}
	}
}