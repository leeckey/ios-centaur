package centaur.display.control
{
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	
	import gs.TweenLite;

	/**
	 *   进度条，带渐进效果
	 *   @author wangq 2013.04.12
	 */ 
	public final class GCProgressBar extends GBuilderBase
	{
		public var forground:GBase;
		public var background:GBase;
		public var scaleProp:String = "scaleY";
		
		private var _max:Number = 1.0;
		private var _currVal:Number = 1.0;
		private var _tweenLite:TweenLite;
		
		public function GCProgressBar(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
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
			
			super.updateDisplayList();
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