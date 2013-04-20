package mcyy.loader.fanim
{
	import com.kingnare.skins.frames.ScaleRulerPanel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mcyy.loader.fanim.AlphaJpegFrameAssemble;
	import mcyy.scene.ShadowAsset;
	
	public class FanimDisplay extends Sprite
	{
		public static const shadowAsset:BitmapData = new ShadowAsset(0, 0);
		private var _info : FanmFileInfo;						// 文件信息
		public var _lstBitmapData : Array = new Array();		// 每一帧的BitmapData
		
		private var _frameCount:uint = 0;						// 需要加载的帧数
		private var _finishCount:uint = 0;						// 已加载结束的帧数
		
		private var _frames:Array = [];
		private var _playFrmCount:int;							// 播放总帧数
		private var _playCurFrm:int;							// 当前播放帧
		private var _isInPlaying:Boolean;
		
		private var _modified:Boolean;
		
		private var _bitmap:Bitmap = new Bitmap();
		
		private var _beginPlayNotifyFunc:Function;
		
		private var _mark:PlusShapeMark = new PlusShapeMark();
		
		public static const _mcyy2famDir:Array = [2,1,0,1,2,3,4,3];
		public static const _mcyyDirSacle:Array = [1,1,1,-1,-1,-1,1,1];
		
		private var _famScale:Number = 1.0;
		
		private var _lockDir:int = -1;									// 方向锁定,-1:不锁,0-7:锁定到mcyy方向
		
		private var _paused:Boolean = false;
		
		private var _selectedIdx:int = -1;
		private var _rulerPanel:ScaleRulerPanel;		// 引用时间轴面板
		
		private var _stopAtEnd:Boolean = false;			// 是否播放时停留在最后一帧
		private var _lastTickTime:int;
		private var _startTime:int;
		private var _frameTime:int;
		private var _elapsePerLoop:int;					// 循环播放一次的时间
		private var _shadowBitmap:Bitmap = new Bitmap(shadowAsset);
		
		public function FanimDisplay()
		{
			super();
			_shadowBitmap.visible = false;
			addChild(_shadowBitmap);
			addChild( _bitmap );
			
			graphics.lineStyle( 1 , 0xff0000 );
			graphics.drawRect( 2 , 2 , 540 , 350 );
			
			graphics.lineStyle( 1 , 0x0000ff );
			graphics.beginFill( 0x00ff00 );
			graphics.drawRect( 502 , 2 , 30 , 30 );
			addChild( _mark );
			
			drawLine( 502 , 2+10 , 532 , 2+10 );
			drawLine( 502 , 2+20 , 532 , 2+20 );
			drawLine( 512 , 2 , 512 , 2+30 );
			drawLine( 522 , 2 , 522 , 2+30 );
			
			this.width = 545;
			this.height = 355;
			addEventListener( MouseEvent.CLICK , onLButtonClick );
		}
		
		public function set selectIdx(value:int):void
		{
			_selectedIdx = value;
		}
		
		public function get selectIdx():int
		{
			return _selectedIdx;
		}
		
		public function set stopAtEnd(value:Boolean):void
		{
			_stopAtEnd = value;
		}
		
		public function get stopAtEnd():Boolean
		{
			return _stopAtEnd;
		}
		
		public function updateFrameRate(frameRate:int):void
		{
			if (_info)
				_info.frameRate = frameRate;
		}
		
		public function registerRulerPanel(rulerPanel:ScaleRulerPanel):void
		{
			_rulerPanel = rulerPanel;
		}
		
		private function drawLine( x1:int , y1:int , x2:int , y2:int ):void
		{
			graphics.moveTo( x1 , y1 );
			graphics.lineTo( x2 , y2 );
		}
		
		private function onLButtonClick( evt:MouseEvent ):void
		{
			if (!_info)
				return;
			
			var mx:int = evt.localX;
			var my:int = evt.localY;
			if( mx>=502 && mx<532 
				&& my>=2 && my<32 )
			{
				mx -= 502;
				my -= 2;
				
				// 小方块内偏移
				mx /= 10;
				my /= 10;
				mx -= 1;
				my -= 1;
				
				var lockDir:int= -1;
				if( mx<0 )
				{
					if( my<0 ) lockDir=3;
					else if( my==0 ) lockDir=4;
					else lockDir = 5;
				}
				else if( mx>0 )
				{
					if( my<0 ) lockDir=1;
					else if( my==0 ) lockDir=0;
					else lockDir = 7;
				}
				else // mx==0
				{
					if( my<0 ) lockDir=2;
					else if( my>0 ) lockDir = 6;
				}
				
				this._lockDir = lockDir;
				if (famDirCount != 5)	// 不是5方向，选择方向无意义，默认无方向
					_lockDir = -1;
				
				if (_lockDir >= 0)
				{
					var famDir:uint = this.mcyyDir2famDir( _lockDir );			// mcyy方向转fam方向
					var frmBegin:int = this.getDirFrmBegin( famDir );
					_playCurFrm = frmBegin - 1;
				}
				else
				{
					_playCurFrm = -1;
				}
				this.selectIdx = -1;
				this.stopAtEnd = true;
				_startTime = getTimer();
				this._elapsePerLoop = 0;
			}
			
			_rulerPanel.updateFrameValue();
			//trace( evt.localX , evt.localY );
		}
		
		public function set beginPlayNotifyFunc( func:Function ):void
		{
			_beginPlayNotifyFunc = func;
		}
		
		public function loadFromFileInfo( info:FanmFileInfo ) : Boolean
		{
			_info = null;								// 关闭
			clearPlay();
			_lstBitmapData = [];
			_finishCount = 0;
			
			if( !info||!info.count )
				return false;
			
			_frameCount = info.count;
			if (info.swfBytes)
			{
				var context:LoaderContext = new LoaderContext(/*false, ApplicationDomain.currentDomain*/);
				context.allowCodeImport = true;
				var swfLoader:Loader = new Loader();
				swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoadComplete);
				swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
				swfLoader.loadBytes(info.swfBytes, context);
			}
			else
			{
				for( var iFrm:uint=0; iFrm<_frameCount; ++iFrm )
				{
					var frmDataObj:Object = info.bitmapDatas[iFrm];			// 帧数据对象
					var frmOffObj:Object  = info.offsets[iFrm];				// 帧偏移信息对象
					
					
					var cx:int = frmOffObj.cx;
					var cy:int = frmOffObj.cy;
					var rw:int = frmOffObj.rw;
					var rh:int = frmOffObj.rh;
					
					if( FanmFileInfo.COMPTYPE_JPEGALPHA==info.compType )
					{
						// jpeg Alpha
						var dataJpeg:ByteArray = frmDataObj.jpegData as ByteArray;
						var dataAlpha:ByteArray = frmDataObj.alphaData as ByteArray;
						if( dataAlpha )
						{
							var newDataAlpha:ByteArray = new ByteArray;
							newDataAlpha.writeBytes( dataAlpha , 0 , dataAlpha.length ) ;
							newDataAlpha.uncompress();
	
							dataAlpha = newDataAlpha;			//  解压　alpha 数据
						}
						
						// 组装BitmapData
						var frameAssemble:AlphaJpegFrameAssemble = new AlphaJpegFrameAssemble( iFrm );
						frameAssemble.rect = new Rectangle( cx , cy , rw , rh );
						frameAssemble.addEventListener(AlphaJpegFrameAssemble.COMPLETE, onFrmAssembleComplete);
						frameAssemble.addEventListener(AlphaJpegFrameAssemble.ERROR, onFrmAssembleError);
						
						frameAssemble.load( dataJpeg , dataAlpha );
					}
					else
					{
						// png 8
						var dataPng8:ByteArray = frmDataObj as ByteArray;
						
						var pngLoader : PngLoader = new PngLoader( "" , iFrm );
						pngLoader.rect = new Rectangle( cx , cy , rw , rh );
						pngLoader.addEventListener(PngLoader.COMPLETE, onPng8FrmComplete);
						pngLoader.addEventListener(PngLoader.ERROR, onFrmAssembleError);
						
						pngLoader.loadFromData( dataPng8 );
					}
				}
			}
			
			_info = info;
			return true;
		}
		
		private function onPng8FrmComplete( evt:Event ):void
		{
			var pngLoader : PngLoader = evt.target as PngLoader;
			
			var rect:Rectangle = pngLoader.rect;
			var objFrame:Object = { cx:rect.x , cy:rect.y , rw:rect.width , rh:rect.height , bitmapData:pngLoader.bd };
			_lstBitmapData[ pngLoader.seq ] = objFrame ;
			++_finishCount;
			if( _finishCount==_frameCount )
			{
				// 全部结束
				// OK,可以显示了
				beginPlay();
			}
		}
		
		private function onFrmAssembleComplete( evt:Event ):void
		{
			var frameAssemble:AlphaJpegFrameAssemble = evt.target as AlphaJpegFrameAssemble;
			
			var rect:Rectangle = frameAssemble.rect;
			var objFrame:Object = { cx:rect.x , cy:rect.y , rw:rect.width , rh:rect.height , bitmapData:frameAssemble.bitmapData };
			_lstBitmapData[ frameAssemble.iIdx ] = objFrame ;
			++_finishCount;
			if( _finishCount==_frameCount )
			{
				// 全部结束
				// OK,可以显示了
				beginPlay();
			}
		}
		
		private function onSWFLoadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = (e.target as LoaderInfo);
			var domain:ApplicationDomain = loaderInfo.applicationDomain;
			loaderInfo.loader.unload();////----wangq
			for (var i:int = 0; i < _frameCount; ++i)
			{
				var cls:Class = getOrientClass(domain, _info.generateClassName(i));
				
				var offsetObj:Object = _info.offsets[i];
				var objFrame:Object = { cx:offsetObj.cx , cy:offsetObj.cy , rw:offsetObj.rw , rh:offsetObj.rh , bitmapData:(cls ? new cls() : null) };
				_lstBitmapData[i] = objFrame;
			}
			
			_finishCount = _frameCount;
			beginPlay();
		}
		
		private function onIOErrorHandler(e:IOErrorEvent):void
		{
		}
		
		private function getOrientClass(domain:ApplicationDomain, clsName:String):Class
		{
			var cls:Class;
			try
			{
				if (!domain)
					domain = ApplicationDomain.currentDomain;
				if (domain)
					cls = domain.getDefinition(clsName) as Class;
			}
			catch (rrr:Error)
			{
				trace("error");
			}
			
			return cls;
		}
		
		private function onFrmAssembleError( evt:Event ):void
		{
			// 出错
			trace( "onFrmAssembleError" );
		}
		
		private function clearPlay():void
		{
			if( _isInPlaying )
			{
				removeEventListener( Event.ENTER_FRAME , onEnterFrame );
				_isInPlaying = false;
			}
			
			this._modified = false;
		}
		
		private function onEnterFrame( evt : Event ):void
		{
			if( !_isInPlaying )
			{
				return;
			}
			
			if( this._paused )
				return;
			
			if (_lastTickTime == 0)
				_lastTickTime = getTimer();
			var dt:int = getTimer() - _lastTickTime;
			_lastTickTime = getTimer();
			if (_info.frameRate != this.stage.frameRate)
			{
				var frameTime:int = 1000 / _info.frameRate;
				_frameTime += dt;
				if (_frameTime < frameTime)
				{
					return;
				}
				
				_frameTime -= frameTime;
			}
			
			_playFrmCount = _frames.length;
			var frmBegin:int = 0;
			var frmEnd:int = _playFrmCount;
			
			var frameScale:int = _mcyyDirSacle[_lockDir%8];
			if( _lockDir>=0 )
			{
				// 方向锁定
				var famDir:uint = this.mcyyDir2famDir( _lockDir );			// mcyy方向转fam方向
				frmBegin = this.getDirFrmBegin( famDir );
				frmEnd = this.getDirFrmEnd( famDir );
			}
			else
			{
				frameScale = 1;
			}
			
			var oldFrm:int = _playCurFrm;
			++_playCurFrm;
			if( _playCurFrm>=frmEnd )
			{
				if (_stopAtEnd)
					this._playCurFrm = frmEnd - 1;
				else
					this._playCurFrm = frmBegin;					// 回绕
			}
			
			// 当前有选择的帧，停在当前帧
			if (_selectedIdx >= 0)
				_playCurFrm = _selectedIdx;
			
			if( _playCurFrm>=_frames.length )
				return;
			
			
			if (_playCurFrm == frmBegin || (_selectedIdx >= 0))
			{
				_elapsePerLoop = 0;
			}
			else if (oldFrm != _playCurFrm)
			{
				// 走帧，计算时间
				if (_startTime == 0)
					_startTime = getTimer();
				var delta:int = getTimer() - _startTime;
				_startTime = getTimer();
				_elapsePerLoop += delta;
			}
			
			var bdIdx:int = _frames[_playCurFrm];
			var objFrame:Object = _lstBitmapData[ bdIdx ]
			var bd:BitmapData = objFrame.bitmapData;
			
			// 260 , 200
			_bitmap.bitmapData = bd;
			relocFrameBitmap( frameScale );
			
			this._bitmap.scaleX = frameScale * _famScale;	
			this._bitmap.scaleY = _famScale;
			
			if (_rulerPanel)
			{
				_rulerPanel.setFrameSelect(_playCurFrm);
				_rulerPanel.timeLinePanel.updatePlayTime(_elapsePerLoop);
			}
		}
		
		private function relocFrameBitmap( scalX:int=1 ):void
		{
			var bdIdx:int = _frames[_playCurFrm];
			var objFrame:Object = _lstBitmapData[ bdIdx ]
			_mark.x = _info.ox * _famScale;
			_mark.y = _info.oy * _famScale;
			_bitmap.x = (_info.ox - objFrame.cx * scalX) * _famScale;
			_bitmap.y = (_info.oy - objFrame.cy) * _famScale;
			
			_shadowBitmap.x = _mark.x - _shadowBitmap.width * 0.5;
			_shadowBitmap.y = _mark.y - _shadowBitmap.height * 0.5;
		}
		
		private function beginPlay():void
		{
			trace( "beginPlay" );
			if( !_info )
				return;
			
			if( _beginPlayNotifyFunc != null )
			{
				_beginPlayNotifyFunc( this );
			}
			
			if( _isInPlaying )
			{
				clearPlay();
			}
			
			// 创建播放帧序列
			reinitPlayFrames();
			
			if (_rulerPanel)
				_rulerPanel.updateFrameValue();
				
			_startTime = getTimer();
			_elapsePerLoop = 0;
			_isInPlaying = true;
			addEventListener( Event.ENTER_FRAME , onEnterFrame );
		}
		
		public function reinitPlayFrames():void
		{
			_frames = _info.frames;
			
			_playFrmCount = _frames.length;
			_playCurFrm = -1;						// 重置为0帧
			_selectedIdx = -1;
			_startTime = getTimer();
			_elapsePerLoop = 0;
			_lockDir = -1;
		}
		
		/**
		 * 修改缩放比 
		 * @param scaleRatio
		 * 
		 */
		public function set famScale( scaleRatio:Number ):void
		{
			_famScale = scaleRatio;
		}
		
		public function get famScale():Number
		{
			return _famScale;
		}
		
		public function set paused( flag:Boolean ):void
		{
			_paused = flag;
			
			this.selectIdx = -1;
			_startTime = getTimer();
		}
		
		public function get paused():Boolean
		{
			return _paused;
		}
		
		public function showShadow(show:Boolean):void
		{
			_shadowBitmap.visible = show;
		}
		
		/**
		 * 修改注册点 
		 * @param ox
		 * @param oy
		 * 
		 */
		public function setOxy( ox:int , oy:int ):void
		{
			if( !isPlaying )
				return;						// 不在播放中不允许修改
			
			if( !_info )
				return;
			
			if( ox==_info.ox && oy==_info.oy )
				return;						// 没有改变
			
			var oldOx : int = _info.ox;
			var oldOy : int = _info.oy;
			_info.ox = ox;
			_info.oy = oy;
			var dx:int = ox - oldOx;		// 改变量
			var dy:int = oy - oldOy;
			
			// 修正每一帧
			for( var i:uint=0; i<_lstBitmapData.length; ++i )
			{
				var objFrame:Object = _lstBitmapData[ i ];
				var frmOffObj:Object  = _info.offsets[ i ];				// 帧偏移信息对象
				objFrame.cx += dx;
				objFrame.cy += dy;
				frmOffObj.cx = objFrame.cx;
				frmOffObj.cy = objFrame.cy;
			}
			this._modified = true;
			
			relocFrameBitmap();
		}
		
		public function get info() : FanmFileInfo
		{
			return _info;
		}
		
		public function get isPlaying():Boolean
		{
			return this._isInPlaying;
		}
		
		public function get modifyFlag():Boolean
		{
			return this._modified;
		}
		
		public function set modifyFlag( modFlag:Boolean ) : void
		{
			this._modified = modFlag;
		}
		
		public function set frameType( frmType:int ):void
		{
			if( !isPlaying )
				return;						// 不在播放中不允许修改
			
			if( !_info )
				return;
			
			_info.frameType = frmType;
			_info.updateFrames();
			this._modified = true;
			
			reinitPlayFrames();				// 重初始化播放帧序列
		}
		
		// fam中的方向数
		public function get famDirCount():uint
		{
			if (!_info)
				return 1;
			
			if( !isPlaying || !_info )
				return 1;
			
			if(_info.isDirect5 && ( 0==(_info.frames.length % 5) ))
				return 5;					// 可以被5整除
			return 1;
		}
		
		// 每方向帧数
		public function get FrmPerDir():uint
		{
			if (!_info)
				return 0;
			
			var famdircnt:uint = this.famDirCount;
			if(5 == famdircnt)
				return _info.frames.length / 5;
			else
				return _info.frames.length;
		}
		
		public function getDirFrmBegin( dir:uint ): uint
		{
			var famdircnt:uint = this.famDirCount;
			if( 5!=famdircnt )
				return 0;
			
			if( dir>=5 ) dir = 0;
			return FrmPerDir * dir;
		}
		
		public function getDirFrmEnd( dir:uint ): uint
		{
			var famdircnt:uint = this.famDirCount;
			if( 5!=famdircnt )
				return 0;
			
			if( dir>=5 )
				dir%=5;
			return FrmPerDir * (dir+1);
		}
		
		// 由 mcyy 方向定义转 fam 方向
		public function mcyyDir2famDir( md:uint ) : uint
		{
			var famdircnt:uint = this.famDirCount;
			if( famdircnt!=5 )
				return 0;					// 单方向的,直接返回0方向
			
			md %= 8;
			return _mcyy2famDir[md];
		}
		
		public function get dirLock():int
		{
			return _lockDir;
		}
		
		public function set dirLock( dir:int ):void
		{
			_lockDir = dir;
		}
	}
}
import flash.display.Shape;

class PlusShapeMark extends Shape
{
	public function PlusShapeMark( color:uint=0x0000ff ):void
	{
		graphics.lineStyle( 1 , color );
		graphics.moveTo( -5 , 0 );
		graphics.lineTo( 5 , 0 );
		graphics.moveTo( 0 , -5 );
		graphics.lineTo( 0 , 5 );
	}
}