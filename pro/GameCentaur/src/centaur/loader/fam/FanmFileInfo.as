package centaur.loader.fam
{
	import flash.display.BlendMode;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class FanmFileInfo
	{
		public static const COMPTYPE_JPEGALPHA:uint = 0;
		public static const COMPTYPE_PNG8:uint = 1;
		
		public static const PACKAGE_NAME:String = "a";	// 默认给个包名，后续可扩展
		
		public static const CURRENT_FILEVER:uint = 8;				// 当前文件版本
																	// 版本3:文件头 frameType 后多加了注册点 ox/oy
																	// 版本4:文件头增加isContainAlpha,是否带透明通道数据
																	// 版本5:保存帧序列，保存播放帧率
																	// 版本6:增加是否为5方向的标识
																	// 版本7:fam中的图片资源支持导入到swf，原生的解压性能更高
																	// 版本8:Fam可以配置混合模式
		public function FanmFileInfo()
		{
			bitmapDatas = new Dictionary;
			offsets = new Dictionary;
		}
		
		public function clearUp():void
		{
			action = 0;
			compType = 0;
			
			count = 0;
			
			frameType = 0;
			
			// 清理掉所有ByteArray的内存
			for each (var datas:* in bitmapDatas)
			{
				if (datas is ByteArray)
					(datas as ByteArray).clear();
				else if (datas is Object)
				{
					for each (var bytes:ByteArray in datas)
					{
						if (bytes)
							bytes.clear();
					}
				}
			}
			
			bitmapDatas = new Dictionary;
			offsets = new Dictionary;
			
			famSerialID = 0;
			swfBytes = null;
			FamClassNameHead = null;
		}
		
		public function set datas(data:ByteArray):void
		{
			clearUp();
			
			data.endian = Endian.LITTLE_ENDIAN;
			if( data.length < 6 )
				return ;
			var fileMagic:uint = data.readUnsignedInt();
			if (fileMagic == 0x434E4146)
			{
				// 有压缩，需要解压
				var temp:ByteArray = new ByteArray();
				temp.endian = Endian.LITTLE_ENDIAN;
				data.readBytes(temp);
				temp.uncompress();
				data = temp;
				fileMagic = data.readUnsignedInt();
			}
			
			if( fileMagic != 0x4D4E4146	)
				return;							// 文件头不对
			var fileVersion:uint 	= data.readUnsignedShort();
			
			if( fileVersion < 2 )				// 2之前的版本不再支持
			{
				trace( "fileVersion" + fileVersion + "<当前文件版本" + CURRENT_FILEVER );
				return;
			}
			var frameNum:uint 		= data.readUnsignedShort();
			this.compType 			= data.readUnsignedShort();			// 压缩类型 0: jpeg   1:png8
			var actCode:uint 		= data.readUnsignedShort();			//  动作编码
			this.frameType 			= data.readUnsignedShort();			//  帧频
			
			if( fileVersion>2 )
			{	// 版本3开始,附加 cx , cy
				this.ox					= data.readShort();
				this.oy					= data.readShort();
			}
			if (fileVersion > 3)
			{
				this.isContainAlpha = data.readShort();
			}
			
			this.count = frameNum;
			this.action = actCode;
			
			if (fileVersion > 4)
			{
				this.frameRate = data.readShort();
				this.frames = data.readObject() as Array;
			}
			else
			{
				frameRate = 25;
			}
			
			if ((!frames) || (frames.length == 0))
				this.updateFrames();
			
			if (fileVersion > 5)
				isDirect5 = data.readBoolean();
			else
				isDirect5 = ((frames.length % 5) == 0);

			if (fileVersion > 7)
				this.blendMode = data.readBoolean() ? BlendMode.SCREEN : null;
			
			// 图片资源存储在swf中
			if (fileVersion > 6)
			{
				famSerialID = data.readUnsignedInt();
				
				for (var frm:uint = 0; frm < frameNum; ++frm)
				{
					var cx1:int = data.readShort();
					var cy1:int = data.readShort();
					var rw1:int = data.readShort();
					var rh1:int = data.readShort();
					var offObject1 : Object = {cx:cx1 , cy:cy1 , rw:rw1 , rh:rh1 };
					offsets[ frm ] = offObject1;
				}
				
				swfBytes = new ByteArray();
				data.readBytes(swfBytes);
			}
			else
			{
				// for offsets and bitmapDatas
				for( var iFrm:uint=0; iFrm<frameNum; ++iFrm )
				{
					var dataOffset:int 		= data.readInt();
					var frameDataTotal:int 	= data.readInt();
					var jpegSize:int 		= data.readInt();
					var alphaSize:int 		= frameDataTotal - jpegSize;
					
					var cx:int = data.readShort();
					var cy:int = data.readShort();
					var rw:int = data.readShort();
					var rh:int = data.readShort();
					
					var dataJpeg:ByteArray = new ByteArray();
					var dataAlpha:ByteArray = new ByteArray();
					if( jpegSize )
					{
						dataJpeg.writeBytes( data , dataOffset , jpegSize );
					}
					
					if( alphaSize && isContainAlpha)
					{
						dataAlpha.writeBytes( data , dataOffset+jpegSize , alphaSize );
						//	dataAlpha.uncompress();				//  解压　alpha 数据
					}
					
					var frmObject : Object = null;
					var offObject : Object = {cx:cx , cy:cy , rw:rw , rh:rh };
					if( FanmFileInfo.COMPTYPE_JPEGALPHA==this.compType )
					{
						frmObject = {alphaData:dataAlpha,jpegData: dataJpeg};
					}
					else if( FanmFileInfo.COMPTYPE_PNG8==this.compType )
					{
						frmObject = dataJpeg;
					}
					
					bitmapDatas[ iFrm ] = frmObject;
					offsets[ iFrm ] = offObject;
				}
			}
			
			/*var info:FanmFileInfo = data.readObject() as FanmFileInfo;
			if(info)
			{
			this.action = info.action;
			this.compType = info.compType;
			this.count = info.count;
			this.frameType = info.frameType;
			this.bitmapDatas = info.bitmapDatas;
			this.offsets = info.offsets;
			}*/
		}
		
		public function updateFrames():void
		{
			frames = [];
			for( var i:int=0; i<count; ++i )
			{
				for( var j:int=0; j<frameType; ++j )
				{
					frames.push( i );
				}
			}
		}
		
		public function generateClassName(iFrm:uint):String
		{
			if (!FamClassNameHead)
				FamClassNameHead = PACKAGE_NAME + "." + "Fam" + famSerialID + "_";
			
			return FamClassNameHead + iFrm;
		}
		
		public var action:int;				// 动作
		
		public var compType:int;			// 压缩类型 0: jpeg   1:png8
		
		public var isContainAlpha:int = 1;  // 针对jpeg格式，0 不带alpha通道数据   1 带alpha通道数据
		
		public var count:int;				// 总帧数
		
		public var frameType:int;			// 帧频 , 每帧显示标准帧多少次
		
		public var frames:Array;			// 帧序列表
		
		public var frameRate:int = 25;		// 帧率,默认为25
		
		public var bitmapDatas:Dictionary;	// 各帧帧图片信息 { alphaData, jpegData | png8Data }
		
		public var offsets:Dictionary;		// 各帧偏移信息 { cx,cy,rw,rh }
		
		public var ox:int;					// 注册点
		public var oy:int;
		
		public var isDirect5:Boolean = false; // 是否是5方向动画
		
		public var famSerialID:uint = 0;	// 每个Fam对应一个序列号，目前暂时没有		
		public var swfBytes:ByteArray;		// Fam资源保存的swf二进制数据
		private var FamClassNameHead:String;	// 只是临时存储资源类名头，便于计算
		
		public var path:String;
		public var datasList:Array;
		public var blendMode:String;
	}
}