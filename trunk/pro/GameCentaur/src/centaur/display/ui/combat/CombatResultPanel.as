package centaur.display.ui.combat
{
	import assetscard.images.CombatResultBgAsset;
	import assetscard.images.CombatResultLoseAsset;
	import assetscard.images.CombatResultWinAsset;
	
	import centaur.data.GameConstant;
	import centaur.data.GameDefines;
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	
	import ghostcat.display.GBase;

	public final class CombatResultPanel extends GBase
	{
		private var _grayShape:Shape;
		private var _backBitmap:Bitmap;
		private var _resultBitmap:Bitmap;
		private var _result:int = -1;
		
		private static var _instance:CombatResultPanel;
		public static function get instance():CombatResultPanel
		{
			return _instance ? _instance : (_instance = new CombatResultPanel());
		}
		
		public function CombatResultPanel()
		{
			_grayShape = new Shape();
			_grayShape.graphics.beginFill(0, 0.7);
			_grayShape.graphics.drawRect(0, 0, GameConstant.STAGE_WIDTH, GameConstant.STAGE_HEIGHT);
			_grayShape.graphics.endFill();
			this.addChild(_grayShape);
			
			_backBitmap = new Bitmap();
			this.addChild(_backBitmap);
			_resultBitmap = new Bitmap();
			this.addChild(_resultBitmap);
		}
		
		public function setResult(result:int):void
		{
			if (_result != result)
			{
				_result = result;	
				
				_backBitmap.bitmapData = GlobalAPI.loaderManager.getBitmapByClass(CombatResultBgAsset);
				_resultBitmap.bitmapData = GlobalAPI.loaderManager.getBitmapByClass((_result != 0) ? CombatResultWinAsset : CombatResultLoseAsset);
				_resultBitmap.x = (GameConstant.STAGE_WIDTH - _resultBitmap.width) * 0.5;
				_resultBitmap.y = (GameConstant.STAGE_HEIGHT - _resultBitmap.height) * 0.5;
			}
		}
	}
}