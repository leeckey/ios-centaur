package centaur.interfaces
{
	import flash.utils.Timer;

	/**
	 *   定时器管理器接口，专门处理定时功能
	 */ 
	public interface ITimerManager
	{
		/**
		 *   开启一个定时操作
		 */ 
		function startDelayCall(delay:Number, delayCall:Function, repeat:int = int.MAX_VALUE, parameters:Array = null):Timer;
		
		/**
		 *   手动停止一个定时操作
		 */
		function stopDelayCall(timer:Timer, handler:Function):void;
	}
}