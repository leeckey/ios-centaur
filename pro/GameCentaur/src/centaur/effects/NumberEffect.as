package centaur.effects
{
	import centaur.data.GlobalAPI;
	import centaur.utils.NumberCache;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import gs.TweenLite;

	/**
	 *   数字效果，各种掉血啥的 
	 */ 
	public final class NumberEffect
	{
		private var _damageSprite:Sprite;
		private var _tweenLite:TweenLite;
		
		public function NumberEffect()
		{
		}
		
		public function addNumberEffect(damage:int, type:int, parentObj:Sprite):void
		{
			if (!parentObj)
				return;
			
			_damageSprite = NumberCache.getNumber(damage, type);
			var gPoint:Point = parentObj.localToGlobal(new Point(parentObj.width * 0.5, parentObj.height * 0.8));
			_damageSprite.x = gPoint.x;
			_damageSprite.y = gPoint.y;
			GlobalAPI.layerManager.getTipLayer().addChild(_damageSprite);
			_tweenLite = TweenLite.to(_damageSprite, 0.6, {y : gPoint.y - 70, onComplete : onNumberEffectComplete});
		}
		
		private function onNumberEffectComplete():void
		{
			TweenLite.removeTween(_tweenLite);
			_tweenLite = null;
			
			if (_damageSprite)
			{
				if (_damageSprite.parent)
					_damageSprite.parent.removeChild(_damageSprite);
				
				NumberCache.recycle(_damageSprite);
				_damageSprite = null;
			}
		}
		
	}
}