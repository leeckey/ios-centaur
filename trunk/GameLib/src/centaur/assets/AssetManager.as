package centaur.assets
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import assets.BackgroundClass1;
	import assets.BallClass1;
	import assets.HeroBitmapClass;
	import assets.assets_png;

	/**
	 *   资源管理器，主要负责资源的获取和管理
	 *   @author wangq 2012.08.05
	 */ 
	public final class AssetManager
	{
		public var heroXMLData:XML;
		public var heroBitmap:BitmapData;
		public var background1:BitmapData;
		public var ball1:BitmapData;
		
		[Embed(source="../embed/Hero.xml", mimeType="application/octet-stream")]
		private static var heroXMLClass:Class;
		
		[Embed(source="../embed/ArialFont.png", mimeType="application/octet-stream")]
		private static var heroPNGClass:Class;
		
		
		
		[Embed(source="../assets/assets.xml", mimeType="application/octet-stream")]
		private static var assetsXML:Class;
		
//		[Embed(source="../assets/assets.png")]
		private static var assetsPNG:Class;
		
		// 游戏的总资源
		private static var _assetsXML:XML;
		private static var _assetsPNG:BitmapData;
		private static var _assetsTextureAltas:TextureAtlas;
		
		// 单例
		private static var _singleton:AssetManager;
		public static function get instance():AssetManager
		{
			if (!_singleton)
				_singleton = new AssetManager();
			return _singleton;
		}
		
		public function AssetManager()
		{
			heroXMLData = XML(new heroXMLClass());
			heroBitmap = new HeroBitmapClass();
			background1 = new BackgroundClass1();
			ball1 = new BallClass1();
			
			// 初始化游戏总资源
			_assetsXML = XML(new assetsXML());
			_assetsPNG = new assets_png() as BitmapData;
			_assetsTextureAltas = new TextureAtlas(Texture.fromBitmapData(_assetsPNG, false, true), _assetsXML);
		}
		
		public function getTexture(name:String):Texture
		{
			return _assetsTextureAltas.getTexture(name);
		}
		
		public function getTextures(prefix:String):Vector.<Texture>
		{
			return _assetsTextureAltas.getTextures(prefix);
		}
	}
}