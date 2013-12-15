package centaur.display.control
{
	import centaur.utils.NumberCache;
	
	import flash.display.Sprite;
	
	import ghostcat.ui.controls.GBuilderBase;
	
	import gs.TweenLite;

	/**
	 *   位图式数字控件
	 *   @author wangq 2013.04.30
	 */ 
	public final class GBitmapNumberText extends GBuilderBase
	{
		private var _numSprite:Sprite;
		private var _originWidth:Number;
		private var _originHeight:Number;
		
		private var _lastVal:int = -1;
		private var _numberVal:int;
		private var _type:int;
		
		private var _tweenLite:TweenLite;
		
		public function GBitmapNumberText(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
			
			_originWidth = this.width;
			_originHeight = this.height;
		}
		
		public function setNumber(num:int, type:int, needTransition:Boolean = false):void
		{
			if (_numberVal == num && _type == type)
				return;
			
			_type = type;
			if (needTransition)
			{
				_lastVal = _numberVal;
				_numberVal = num;
				
				// 处理数字变换过度效果
				var numObj:Object = {num : _lastVal};
				removeTween();
				_tweenLite = TweenLite.to(numObj, 0.5, {num : _numberVal, onUpdate : onTransitionUpdate});
			}
			else
			{
				_lastVal = _numberVal = num;
				updateNumber(_numberVal.toString());
			}
		}
		
		public function setStrNumber(numStr:String, type:int):void
		{
			_type = type;
			updateNumber(numStr);
		}
		
		/**
		 *   根据数字的值更新显示
		 */ 
		private function updateNumber(num:String):void
		{
			if (_numSprite)
				NumberCache.recycle(_numSprite);
			_numSprite = NumberCache.getNumber(num, _type);
			if (_numSprite)
				this.addChild(_numSprite);
			
			centerSprite();
		}
		
		private function  centerSprite():void
		{
			// 默认居中显示
			_numSprite.x = (this._originWidth - _numSprite.width) * 0.5;
			_numSprite.y = (this._originHeight - _numSprite.height) * 0.5;
		}
		
		private function removeTween():void
		{
			if (_tweenLite)
				TweenLite.removeTween(_tweenLite);
			_tweenLite = null;
		}
		
		private function onTransitionUpdate():void
		{
			var numObj:Object = _tweenLite ? _tweenLite.target : null;
			if (!numObj)
			{
				removeTween();
				return;
			}
			
			updateNumber(int(numObj.num).toString());
		}
		
		override public function destory():void
		{
			if (_numSprite)
				NumberCache.recycle(_numSprite);
			_numSprite = null;
			
			super.destory();
		}
	}
}