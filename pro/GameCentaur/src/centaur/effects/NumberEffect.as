package centaur.effects
{
	import centaur.data.GlobalAPI;
	import centaur.display.control.GTextField;
	import centaur.utils.NumberCache;
	import centaur.utils.NumberType;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	
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
			
			_damageSprite = new GTextField(GTextField.FONT_SAMPLE1);//NumberCache.getNumber(damage, type);
			(_damageSprite as GTextField).textField.textColor = getColorbyType(type);
			(_damageSprite as GTextField).text = ((damage > 0) ? "+" : "") + String(damage);
			var gPoint:Point = parentObj.localToGlobal(new Point(parentObj.width * 0.5, parentObj.height * 0.8));
			_damageSprite.x = gPoint.x;
			_damageSprite.y = gPoint.y;
			GlobalAPI.layerManager.getTipLayer().addChild(_damageSprite);
			_tweenLite = TweenLite.to(_damageSprite, 0.6, {y : gPoint.y - 70, onComplete : onNumberEffectComplete});
		}
		
		private function getColorbyType(type:int):uint
		{
			if (type == NumberType.ADDBLOOD)
				return 0x00FF00;
			else if (type == NumberType.HIT)
				return 0xFF0000;
		
			return 0xFFFFFF;
		}
		
		private function onNumberEffectComplete():void
		{
			TweenLite.removeTween(_tweenLite);
			_tweenLite = null;
			
			if (_damageSprite)
			{
				if (_damageSprite.parent)
					_damageSprite.parent.removeChild(_damageSprite);
				
//				NumberCache.recycle(_damageSprite);
				if (_damageSprite is GBase)
					(_damageSprite as GBase).destory();
				_damageSprite = null;
			}
		}
		
	}
}