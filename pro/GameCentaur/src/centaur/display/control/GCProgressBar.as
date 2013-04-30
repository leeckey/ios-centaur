package centaur.display.control
{
	import flash.display.Shape;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	
	import gs.TweenLite;

	/**
	 *   进度条，带渐进效果
	 *   @author wangq 2013.04.12
	 */ 
	public final class GCProgressBar extends GBuilderBase
	{
		public static const SCALE_X_POSITIVE:String = "scaleXPositive";
		public static const SCALE_Y_POSITIVE:String = "scaleYPositive";
		public static const MASK_Y_POSITIVE:String = "maskYPositive";
		
		public var forground:GBase;
		public var background:GBase;
		public var progressType:String = MASK_Y_POSITIVE;
		
		private var _groundWidth:Number;
		private var _groundHeight:Number;
		
		private var _forMask:Shape;
		private var _backMask:Shape;
		
		private var _max:Number = 1.0;
		private var _lastVal:Number = 1.0;
		private var _currVal:Number = 1.0;
		private var _tweenLite:TweenLite;
		
		public function GCProgressBar(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
			
			// 前景背景默认重叠，实现渐进效果
			_groundWidth = forground.width;
			_groundHeight = forground.height;
		}
		
		public function setMaxValue(value:Number):void
		{
			if (_max != value)
			{
				_max = value;
				this.invalidateDisplayList();
			}
		}
		
		public function setCurrValue(value:Number):void
		{
			if (_currVal != value)
			{
				_lastVal = _currVal;
				_currVal = value;
				this.invalidateDisplayList();
			}
		}
		
		/**
		 *   更新进度显示
		 */ 
		override protected function updateDisplayList():void
		{
			if (!forground)
				return;
			
			removeTween();
			
			if (progressType == SCALE_Y_POSITIVE || progressType == SCALE_X_POSITIVE)
			{
				updateScaleSelf((progressType == SCALE_Y_POSITIVE) ? "scaleY" : "scaleX");
			}
			else if (progressType == MASK_Y_POSITIVE)	// 暂时只添加部分类型处理，后续根据需求再添加
			{
				updateMaskSelf();
			}
			
			super.updateDisplayList();
		}
		
		private function updateScaleSelf(scaleProp:String):void
		{
			var newScale:Number = (_max > 0) ? (_currVal / _max) : 0;
			var oldScale:Number = forground[scaleProp];
			forground[scaleProp] = newScale;
			if (background)
			{
				// 存在渐进层，处理渐进效果
				background[scaleProp] = oldScale;
				if (newScale < oldScale)
				{
					var tweenObj:Object = {};
					tweenObj[scaleProp] = newScale;
					tweenObj.onComplete = onTweenComplete;
					_tweenLite = TweenLite.to(background, 0.5, tweenObj);
				}
				else
					background[scaleProp] = newScale;
			}
		}
		
		private function updateMaskSelf():void
		{
			if (_lastVal < _currVal)
				_lastVal = _currVal;
			
			var newScale:Number = (_max > 0) ? (_currVal / _max) : 0;
			var oldScale:Number = (_max > 0) ? (_lastVal / _max) : 0;
			
			updateForgroundMask(oldScale, newScale);
			updateBackgroundMask(oldScale, newScale);
		}
		
		private function updateForgroundMask(oldScale:Number, newScale:Number):void
		{
			if (!forground)
				return;
			
			if (!_forMask)
			{
				_forMask = new Shape();
				_forMask.visible = false;
				forground.addChild(_forMask);
				forground.mask = _forMask;
			}
			
			updateMask(_forMask, progressType, newScale);
		}
		
		private function updateBackgroundMask(oldScale:Number, newScale:Number):void
		{
			if (!background)
				return;
			
			if (!_backMask)
			{
				_backMask = new Shape();
				_backMask.visible = false;
				background.addChild(_backMask);
				background.mask = _backMask;
			}
			
			updateMask(_backMask, progressType, oldScale);
			
			// 从oldScale过度到newScale
			if (oldScale != newScale)
			{
				var scaleObj:Object = {scale : oldScale};
				removeTween();
				_tweenLite = TweenLite.to(scaleObj, 1, {scale : newScale, onUpdate : onBackgroundUpdate, onComplete : onTweenComplete});
			}
		}
		
		private function onBackgroundUpdate():void
		{
			var scaleObj:Object = _tweenLite.target as Object;
			if (scaleObj && scaleObj.hasOwnProperty("scale"))
			{
				var scale:Number = scaleObj.scale;
				updateMask(_backMask, progressType, scale);
			}
		}
		
		private function updateMask(mask:Shape, type:String, scale:Number):void
		{
			var startX:Number;
			var startY:Number;
			var maskWidth:Number;
			var maskHeight:Number;
			if (type == MASK_Y_POSITIVE)
			{
				startX = 0;
				startY = _groundHeight * (1 - scale);
				maskWidth = _groundWidth;
				maskHeight = _groundHeight * scale;
			}
			
			mask.graphics.clear();
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(startX, startY, maskWidth, maskHeight);
			mask.graphics.endFill();
		}
		
		private function removeTween():void
		{
			if (_tweenLite)
			{
				TweenLite.removeTween(_tweenLite);
				_tweenLite = null;
			}
		}
		
		private function onTweenComplete():void
		{
			removeTween();
		}
	}
}