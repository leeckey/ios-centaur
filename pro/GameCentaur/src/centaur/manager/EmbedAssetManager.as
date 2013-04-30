package centaur.manager
{
	import assetscard.images.*;
	
	import centaur.data.GlobalAPI;
	
	import flash.utils.ByteArray;

	public final class EmbedAssetManager
	{
//		[Embed(source="../../../../assets/effects/jgjf01.fam",mimeType="application/octet-stream")]
//		private static var FamTestBytes:Class;
		
		private static var _cardRaceList:Array = [CardRace1, CardRace2, CardRace3, CardRace4];
		
		/**
		 *  卡牌的种族背景作为嵌入资源，确保第一时间至少显示背景
		 */ 
		public static function getCardRace(race:int):Class
		{
			return _cardRaceList[race];
		}
		
		public static function setup():void
		{
//			GlobalAPI.loaderManager.setupFam(new FamTestBytes() as ByteArray);
		}
		
	}
}