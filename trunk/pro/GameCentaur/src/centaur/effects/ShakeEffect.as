package centaur.effects
{
	import centaur.data.GlobalAPI;
	import centaur.interfaces.ITick;
	
	import flash.utils.getTimer;
	

	/**
	 *   震动效果，支持2维坐标系下的震动
	 *   @author wangq 2012.06.29
	 */ 
	public final class ShakeEffect implements ITick
	{
		/**
		 *  震动的缓动函数
		 */ 
		private var shakeDirection:Boolean;
		private function shake(t:Number, b:Number, c:Number, d:Number):Number 
		{
			shakeDirection = !shakeDirection;
			return b + c * (1 - (shakeDirection ?  (t / d) : (2 * d - t) / d));
		}
		
		private var _target:Object;				// 需要震动的目标对象，提供2个属性2维震动
		private var _propX:String;				// 目标的X属性
		private var _propY:String;				// 目标的Y属性
		private var _updateHandler:Function;	// 每次震动更新的回调函数
		private var _time:int;					// 总共震动时间
		private var _amp:Number;				// 振幅
		
		private var _startTime:int;				// 开始时间
		
		private var _lastOffsetX:Number = 0.0;	// 上一次震动的偏移量
		private var _lastOffsetY:Number = 0.0;
		
		public function ShakeEffect(target:Object, propX:String = null, propY:String = null, updateHandler:Function = null, time:int = 300, amplitude:Number = 5)
		{
			_target = target;
			_propX = propX;
			_propY = propY;
			_updateHandler = updateHandler;
			_time = time;
			_amp = amplitude;
		}
		
		public function startEffect():void
		{
			// 如果属性都不存在，或者目标含的属性，不处理
			if (!_target || (!_propX && !_propY) ||
				(_propX && !_target.hasOwnProperty(_propX)) ||
				(_propY && !_target.hasOwnProperty(_propY)))
			{
				onEffectComplete();
				return;
			}
			
			_startTime = getTimer();
			_lastOffsetX = 0.0;
			_lastOffsetY = 0.0;
			
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function stopEffect():void
		{
			onEffectComplete();
		}
		
		public function update(times:int, dt:int):void
		{
			var currTime:int = getTimer();
			var progressTime:int = currTime - _startTime;
			progressTime = (progressTime > _time) ? _time : progressTime;
			var offset:Number = shake(progressTime, 0, _amp, _time);
			
			// 根据两次震动的偏移量，计算出当前目标属性需要变动的差值,这样震动不受外界影响
			updateTargetProperties(offset);
			if (_updateHandler != null)
				_updateHandler.apply();
			
			// 时间到，震动结束
			if (progressTime >= _time)
			{
				onEffectComplete();
			}
		}
		
		/**
		 *   更新目标的属性，只精确到小数点后1位，避免目标属性运算时自动略去
		 *   DisplayObject的x属性只保存小数点后2位
		 */ 
		protected function updateTargetProperties(offset:Number):void
		{
			if (_propX && _propY)
			{
				var radian:Number = Math.random() * Math.PI * 2;
				var offsetX:Number = Number((Math.cos(radian) * offset).toFixed(1));
				var offsetY:Number = Number((Math.sin(radian) * offset).toFixed(1));
				_target[_propX] += Number((offsetX - _lastOffsetX).toFixed(1));
				_target[_propY] += Number((offsetY - _lastOffsetY).toFixed(1));
				_lastOffsetX = offsetX;
				_lastOffsetY = offsetY;
			}
			else if (_propX)
			{
				offset = Number(offset.toFixed(1));
				_target[_propX] += Number((offset - _lastOffsetX).toFixed(1));
				_lastOffsetX = offset;
			}
			else if (_propY)
			{
				offset = Number(offset.toFixed(1));
				_target[_propY] += Number((offset - _lastOffsetY).toFixed(1));
				_lastOffsetY = offset;
			}
		}
		
		/**
		 *   震动效果结束，清理掉数据
		 */ 
		protected function onEffectComplete():void
		{
			GlobalAPI.tickManager.removeTick(this);
			_target = null;
			_updateHandler = null;
		}
	}
}