package centaur.movies
{
	import centaur.data.GlobalAPI;
	import centaur.interfaces.IMovieClip;
	import centaur.loader.fam.FanmFileInfo;
	import centaur.loader.loaderdata.PacckageFileData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 *   Fanm通用动画类,任何需要扩展功能的可继承或组合此类
	 *   @author wangq 2012.06.12
	 */ 
	public class FanmMovieClip extends Sprite implements IMovieClip
	{
		/** 动画的Fanm资源路径 */
		private var _path:String;
		
		/** 资源加载完成的回调函数 */
		private var _completeCallback:*;
		
		/** 加载完成的回调数组 */
		private var _callBack:Array;
		
		/** 是否自动开始播放 */
		private var _autoPlay:Boolean = true;
		
		/** 表示当前动画是否暂停 */
		private var _paused:Boolean = true;
		
		/** 动画数据 */
		private var _data:FanmFileInfo;
		
		/** 动画的承载体 */
		private var _bitmap:Bitmap;
		
		/** 帧的索引数组 */
		private var _frames:Array = [];
		
		/** 帧的索引数据长度，因为_frames初始化就不会变更，所以将长度保存起来不用频繁计算，提高效率 */
		protected var _frameLength:int;
		
		/** 帧播放时的起始帧索引 */
		protected var _startFrameIndex:int;
		
		/** 帧播放时的结束帧索引 */
		protected var _endFrameIndex:int;
		
		/** 当前帧在索引数组中的位置 */
		protected var _frameIndex:int = -1;
		
		/** 当前播放帧 */
		private var _currentFrame:int = -1;
		
		/** 表示动画开始播放时的开始帧 */
		private var _startFrame:int = -1;
		
		/** 表示动画循环的次数，如果为-1表示无限循环 */
		private var _loop:int = -1;
		
		/** 表示是否已经析构 */
		private var _destoryed:Boolean = false;
		
		/** 当前是否处于资源加载中 */
		private var _isLoading:Boolean = false;
		
		/** 保存当前帧对应的动画数据 */
		private var _currFileData:PacckageFileData;
		
		/** 标记加载效果资源超时，无需继续播放,停止播放即可  */
		private var _clearTimeOut:int = -1;
		private var _startLoadTime:int = int.MAX_VALUE;
		
		/** 从Fam文件中读取,默认为25 */
		private var _frameRate:int = 25;
		private var _frameTime:int = 40;
		private var _currentTime:int;
		private var _frameDatas:Array;
		
		private var _playDirect:int = -1;	// 播放方向，效果带方向才起作用
		private var _mirrorX:int = 1;		// 左右镜像参数
		
		public function FanmMovieClip(fanmPath:String = null, loopNum:int = -1, autoPlay:Boolean = true)
		{
			_path = fanmPath;
			_loop = loopNum;
			_autoPlay = autoPlay;
			_callBack = [];
			this.blendMode = BlendMode.NORMAL;
			super();
			
			setup();
		}
		
		public function dispose():void
		{
			_destoryed = true;
			
			clear();
			if (_bitmap)
			{
				_bitmap.bitmapData = null;
				if (_bitmap.parent)
					_bitmap.parent.removeChild(_bitmap);
				_bitmap = null;
			}
			
			if (parent)
				parent.removeChild(this);
		}
		
		public function getContent():Bitmap
		{
			return this._bitmap;
		}
		
		public function get type():int
		{
			return MovieClipFactory.FAM_MOVIE_TYPE;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function set clearTimeOut(value:int):void
		{
			_clearTimeOut = value;
		}
		
		public function get isLoading():Boolean
		{
			return this._isLoading;
		}
		
		public function get frameIndex():int
		{
			return this._frameIndex;
		}
		
		public function get frameRate():int
		{
			return this._frameRate;
		}
		
		public function get frameLength():int
		{
			return this._frameLength;
		}
		
		public function manualSetFrame(idx:int):void
		{
			this.setFrame(idx);
		}
		
		public function addLoadCompleteCallback(callback:Function):void
		{
			if (!_callBack)
				_callBack = [];
			if (callback != null && (_callBack.indexOf(callback) == -1))
			{
				_callBack.push(callback);
			}
		}
		
		public function setStartFrame(startFrame:int):void
		{
			_startFrame = startFrame;
			
			// 如果已经加载完,并且刚开始播放,则按照开始帧进行播放
			if (!_isLoading && _currentFrame <= 0)
			{
				_frameIndex = (_startFrame <= 0) ? -1 : _startFrame * _data.frameType;
			}
		}
		
		public function setDirect(direct:int):void
		{
			if (_playDirect == direct)
				return;
			
			_playDirect = direct;
			
			if (_data)
			{
				this.initPlayFrameSegment();
				this.setFrame(_startFrameIndex);
			}
		}
		
		public function getDirect():int
		{
			return _playDirect;
		}
		
		public function clear():void
		{
			if (!_paused)
			{
				_paused = true;
				GlobalAPI.tickManager.removeTick(this);
			}
			
//			if (_path)
//				GlobalAPI.loaderAPI.removeFanmAQuote(_path, onResLoadComplete);
			_path = null;
			_data = null;
			_frameDatas = null;
			_currFileData = null;
			_completeCallback = null;
			if (_callBack)
				_callBack.length = 0;
			_frames = null;
			_frameLength = 0;
			_currentFrame = -1;
			_startFrame = -1;
			_frameIndex = -1;
			_currentTime = 0;
			_frameRate = 25;
			_frameTime = 40;
			_clearTimeOut = -1;
			_startLoadTime = int.MAX_VALUE;
			this.visible = true;
			if(_bitmap)
			{
				_bitmap.bitmapData = null;
				_bitmap.x = _bitmap.y = 0;
				_bitmap.scaleX = _bitmap.scaleY = 1;
			}
			this.mouseChildren = this.mouseEnabled = false;
			_playDirect = -1;
			_startFrameIndex = _endFrameIndex = 0;
			_mirrorX = 1;
			this.blendMode = BlendMode.NORMAL;
		}
		
		public function setLoop(loop:int):void
		{
			_loop = loop;
		}
		
		public function getPaused():Boolean
		{
			return _paused;
		}
		
		public function gotoAndPlay(frame:int):void
		{
			// 设置好当前帧的播放索引，Tick时会自动向后推进
			if (_data)
				setFrame(frame * _data.frameType);
			
			if (_paused)
			{
				_paused = false;
				GlobalAPI.tickManager.addTick(this);
			}
		}
		
		public function gotoAndStop(frame:int):void
		{
			// 设置好当前帧的播放索引
			if (_data)
				setFrame(frame * _data.frameType);
			
			if (!_paused)
			{
				_paused = true;
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		public function play():void
		{
			gotoAndPlay(0);
		}

		public function stop():void
		{
			gotoAndStop(0);
		}
		
		/**
		 *   更新动画
		 */ 
		public function update(times:int, delta:int):void
		{
			if (_frameRate != 25)
			{
				_currentTime += delta;
				if (_currentTime < _frameTime)
					return;
				
				times = int(_currentTime / _frameTime);
				_currentTime -= _frameTime * times;
			}
			
			// 设置动画播放
			setFrame(_frameIndex + times);
		}
		
		public function manualUpdate(bitmapData:BitmapData, posX:Number, posY:Number, scaleX:int = 1, scaleY:int = 1):void
		{
			if (!_bitmap)
				return;
			
			_bitmap.bitmapData = bitmapData;
			_bitmap.x = posX;
			_bitmap.y = posY;
			_mirrorX = _bitmap.scaleX = scaleX;
			_bitmap.scaleY = scaleY;
		}
		
		public function getCurrFileData():PacckageFileData
		{
			return _currFileData;
		}
		
		public function setPath(path:String, completeCallback:* = null, clearType:int = 0/*SourceClearType.CHANGESCENE_AND_TIME*/, clearTime:int = 30000):void
		{
			_path = path;
			_completeCallback = completeCallback;
			
			loadResources(clearType, clearTime);
		}
		
		public function setFrameRate(frameRate:int):void
		{
			// 暂时不控制Fam动画的播放帧频
		}
		
		protected function setup():void
		{
			// 初始化显示对象
			this.mouseChildren = this.mouseEnabled = false;
			_bitmap = new Bitmap();
			this.addChild(_bitmap);
			
			loadResources();
		}
		
		protected function loadResources(clearType:int = 0/*SourceClearType.CHANGESCENE_AND_TIME*/, clearTime:int = 30000):void
		{
			// 加载资源
			if (_path)
			{
				_isLoading = true;
				_startLoadTime = getTimer();
//				GlobalAPI.loaderAPI.getFanmFile(_path, onResLoadComplete, clearType, clearTime);
				GlobalAPI.loaderManager.getFamFile(_path, onResLoadComplete);
			}
			else
				onResLoadComplete(null);
		}
		
		/**
		 *   资源加载完成后，初始化数据，并且默认开始播放
		 */ 
		protected function onResLoadComplete(data:Object):void
		{
			_isLoading = false;
			_startLoadTime = int.MAX_VALUE;
			
			// 如果没有获取到动画资源，直接清理掉，并发出完成事件
			if (!data)
			{
				clear();
				if (hasEventListener(Event.COMPLETE))
					dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			// 如果该对象已经析构，直接不初始化
			if (_destoryed)
				return;
			
			// 初始化数据，初始化动画帧
			initData(data);
			this.setFrame(_startFrameIndex);
			
			// 资源加载完成的回调函数
//			if (_completeCallback is Handler)
//				(_completeCallback as Handler).call();
			/*else */if (_completeCallback is Function)
				(_completeCallback as Function).apply();
			_completeCallback = null;
			if (_callBack)
			{
				for each (var func:Function in _callBack)
				{
					if (func != null)
						func.apply(null, [this]);
				}
				_callBack.length = 0;
			}
		}
		
		protected function initData(data:Object):void
		{
			_data = data as FanmFileInfo;
			_frameIndex = (_startFrame <= 0) ? -1 : _startFrame * _data.frameType;
			_currentFrame = -1;
			
			// 保存帧数据
			_frames = _data.frames;
			_frameLength = _frames ? _frames.length : 0;
			_frameRate = _data.frameRate;
			_frameDatas = _data.datasList;
			if (_frameRate <= 0)
				_frameRate = 25;
			_frameTime = 1000 / _frameRate;
			if (_data.blendMode)
				this.blendMode = _data.blendMode;
			
			// 初始化播放的帧区间
			initPlayFrameSegment();
		}
		
		/**
		 *   初始化播放的帧区间
		 */ 
		private function initPlayFrameSegment():void
		{
			var actionStepLen:int = _frameLength * 0.2;
			if (_playDirect < 0)
			{
				_startFrameIndex = 0;
				_endFrameIndex = _frameLength;
			}
			_mirrorX = /*DirectType.isLeft(_playDirect) ? -1 : */1;
		}
		
		protected function setFrame(frame:int):void
		{
			if (!_data)
			{
				// 对于未加载完的效果资源，如果停止加载或加载超时，直接停止掉
				if ((!_isLoading) || checkTimeOut())
				{
					clear();
					if (hasEventListener(Event.COMPLETE))
						dispatchEvent(new Event(Event.COMPLETE));
				}
				return;
			}
			
			// 如果当前没有数据，则不需要处理
			if (_frameIndex == frame)
				return;
			
			// 计算出当前帧
			_frameIndex = (frame < _startFrameIndex) ? _startFrameIndex : (frame >= _endFrameIndex ? (_endFrameIndex - 1) : frame);
			frame = _frames[_frameIndex];
			if (_currentFrame != frame)
			{
				// 根据当前帧数更新动画显示
				_currentFrame = frame;
				_currFileData = _frameDatas[_currentFrame] as PacckageFileData;
				if (_currFileData)
				{
					_bitmap.bitmapData = _currFileData.data;
					_bitmap.scaleX = _mirrorX;
					_bitmap.x = (_mirrorX == -1) ? -_currFileData.x : _currFileData.x;
					_bitmap.y = _currFileData.y;
				}
			}
			
			// 如果循环播放结束，则发出动画结束事件
			if (_frameIndex == _endFrameIndex - 1)
			{
				if (_loop > 0)
					_loop--;
				_frameIndex = -1;
				_currentFrame = -1;
			}
			if (_loop == 0)
			{
				_loop = -1;
				_currentFrame = -1;
				_startFrame = -1;
				_frameIndex = -1;
				GlobalAPI.tickManager.removeTick(this);
				if (hasEventListener(Event.COMPLETE))
					dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 *   判断当前是否加载超时
		 */ 
		private function checkTimeOut():Boolean
		{
			return (_clearTimeOut > 0) && (getTimer() - _startLoadTime > _clearTimeOut);
		}
		
	}
}