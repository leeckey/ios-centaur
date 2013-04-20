package mcyy.loader.fanim
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mcyy.utils.BitmapUtils;

	public class FamFileWrite
	{
		public function FamFileWrite()
		{
		}
		
		public static function writeFamFile( pF:FanmFileInfo , filename:String ) : void
		{
			
			var curFanmFileVer:uint = FanmFileInfo.CURRENT_FILEVER;				// 20120425 cpp , 调整成 v2 版本, 支持 jpegAlpha/png8 采用流模式/非 readObject/writeObject
			
			var fdata:ByteArray = new ByteArray();
			fdata.endian = Endian.LITTLE_ENDIAN;
			
			// 文件信息
			fdata.writeUnsignedInt( 0x4D4E4146 );		//  文件头 'FANM'
			fdata.writeShort( curFanmFileVer );			// 文件版本号
			fdata.writeShort( pF.count );				// 帧数
			fdata.writeShort( pF.compType );			// 压缩类型 0: jpeg   1:png8
			fdata.writeShort( pF.action );				//  动作编码
			fdata.writeShort( pF.frameType );			//  帧频
			fdata.writeShort( pF.ox );					//  注册点 oxy
			fdata.writeShort( pF.oy );					//  
			fdata.writeShort(pF.isContainAlpha);		// 针对jpeg格式，0 不带alpha通道数据   1 带alpha通道数据
			fdata.writeShort(pF.frameRate);				// 播放帧率
			fdata.writeObject(pF.frames);				// 播放的帧序列
			fdata.writeBoolean(pF.isDirect5);			// 播放是否是5方向
			
			if (curFanmFileVer > 6)
			{
				fdata.writeUnsignedInt(pF.famSerialID);
				for (var frm:uint = 0; frm < pF.count; ++frm)
				{
					var frmOffObj:Object 	 = pF.offsets[frm];
					fdata.writeShort(frmOffObj.cx);
					fdata.writeShort(frmOffObj.cy);
					fdata.writeShort(frmOffObj.rw);
					fdata.writeShort(frmOffObj.rh);
				}
				
				// 写入swf字节流
				if (!pF.swfBytes)
					pF.swfBytes = BitmapUtils.FamToSWFBytes(pF);
				if (pF.swfBytes)
					fdata.writeBytes(pF.swfBytes, 0, pF.swfBytes.length);
			}
			else
			{
				// offset = fdata.position , 开始写 FrameInfo
				var frmInfoBeginOffset:int = fdata.position;
				var curOffset:int = frmInfoBeginOffset + 20 * pF.count;		// 跳过帧信息
				for( var iFrm:uint=0; iFrm<pF.count; ++iFrm )
				{
					var fanmFrameObj:Object = pF.bitmapDatas[iFrm];	// 取出当前帧数据
					var frmOffObj:Object 	 = pF.offsets[iFrm]; 
					var frmIdx:int = iFrm;
					var cx:int = frmOffObj.cx;
					var cy:int = frmOffObj.cy;
					var rw:int = frmOffObj.rw;
					var rh:int = frmOffObj.rh;
					var dataJpeg:ByteArray = null;
					var dataAlpha:ByteArray = null;
					if( FanmFileInfo.COMPTYPE_JPEGALPHA == pF.compType )
					{
						// jpegAlpha
						dataJpeg = fanmFrameObj.jpegData;
						
						// 确定是否需要写入alpha数据
						if (pF.isContainAlpha)
							dataAlpha = fanmFrameObj.alphaData;
					}
					else if( FanmFileInfo.COMPTYPE_PNG8 == pF.compType )
					{
						// png8
						dataJpeg = fanmFrameObj as ByteArray;				// ByteArray
					}
					
					fdata.writeInt( curOffset );								// 数据偏移
					fdata.writeInt( (dataJpeg ? dataJpeg.length : 0) + (dataAlpha?dataAlpha.length:0) );		// 图像数据总大小
					fdata.writeInt( (dataJpeg ? dataJpeg.length : 0) );
					fdata.writeShort(cx);
					fdata.writeShort(cy);
					fdata.writeShort(rw);
					fdata.writeShort(rh);
					
					curOffset += (dataJpeg ? dataJpeg.length : 0) + (dataAlpha?dataAlpha.length:0);			// 下移到下一位置
				}
				
				// 写入帧数据
				for( iFrm=0; iFrm<pF.count; ++iFrm )
				{
					var fanmFrameObj:Object = pF.bitmapDatas[iFrm];	// 取出当前帧数据
					var frmIdx:int = iFrm;
					
					var dataJpeg:ByteArray = null;
					var dataAlpha:ByteArray = null;
					if( FanmFileInfo.COMPTYPE_JPEGALPHA == pF.compType )
					{
						// jpegAlpha
						dataJpeg = fanmFrameObj.jpegData;
						
						// 确定是否需要写入alpha数据
						if (pF.isContainAlpha)
							dataAlpha = fanmFrameObj.alphaData;
					}
					else if( FanmFileInfo.COMPTYPE_PNG8 == pF.compType )
					{
						// png8
						dataJpeg = fanmFrameObj as ByteArray;				// ByteArray
					}
					
					if( dataJpeg )
					{
						fdata.writeBytes( dataJpeg );
					}
					if( dataAlpha )
					{
						fdata.writeBytes( dataAlpha );
					}
				}
			}
			
			// OK,fdata为文件数据
			
			//fdata.writeObject(pF);
			
			// 处理压缩
			if (pF.isCompress)
			{
				var oldSize:uint = fdata.length;
				fdata.compress();
				var newSize:uint = fdata.length;
				var needCompress:Boolean =  (Number(newSize / oldSize) < 0.8);
				
				// 达到一定的压缩比率才去压缩
				if (needCompress)
				{
					var temp:ByteArray = new ByteArray();
					temp.endian = Endian.LITTLE_ENDIAN;
					temp.writeUnsignedInt(0x434E4146);
					fdata.position = 0;
					temp.writeBytes(fdata);
					fdata = temp;
				}
				else
					fdata.uncompress();
			}
			
			var swfStream:FileStream = new FileStream();
			
			swfStream.open( new File( filename ) , FileMode.WRITE);
			
			swfStream.writeBytes(fdata);
			
			swfStream.close();
			swfStream = null;
		}
	}
}