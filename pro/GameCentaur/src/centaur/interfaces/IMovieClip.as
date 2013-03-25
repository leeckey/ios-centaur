package centaur.interfaces
{
	/**
	 *   动画效果的接口
	 *   @author wangq 2012.07.26
	 */ 
	public interface IMovieClip extends ITick, IDisplayObject
	{
		/**
		 *  动画的名称
		 */ 
		function get name():String;
		
		/**
		 *   动画的类型
		 */
		function get type():int;
		
		/**
		 *   清理掉动画
		 */
		function clear():void;
		
		/**
		 *   是否暂停
		 */
		function getPaused():Boolean
		
		/**
		 *   设置循环播放的次数
		 */
		function setLoop(loop:int):void;
		
		/**
		 *   从指定帧开始播放动画
		 */
		function gotoAndPlay(frame:int):void;
		
		/**
		 *   移动到指定帧并停在那里
		 */
		function gotoAndStop(frame:int):void;
		
		/**
		 *  从动画头开始播放
		 */
		function play():void;
		
		/**
		 *   停止在动画头帧的位置
		 */
		function stop():void;
		
		/**
		 *   设置动画资源的路径
		 */
		function setPath(path:String, completeCallback:* = null, clearType:int = 4, clearTime:int = 30000):void;
		
		/**
		 *   设置动画的播放帧频
		 */ 
		function setFrameRate(frameRate:int):void;
		
		/**
		 *   获取当前动画播放的帧
		 */ 
		function get currentFrame():int;
		
		/**
		 *   设置动画开始播放的帧
		 */ 
		function setStartFrame(startFrame:int):void;
		
		/**
		 *   设置加载超时后的清除的超时时间(ms)
		 */ 
		function set clearTimeOut(value:int):void;
		
		/**
		 *  设置效果播放的方向，这个暂时只支持Fam格式的动画
		 */
		function setDirect(direct:int):void;
		
		/**
		 *  获取效果播放的方向，这个暂时只支持Fam格式的动画
		 */
		function getDirect():int;
	}
}