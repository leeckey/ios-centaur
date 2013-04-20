
import com.kingnare.skins.frames.ScaleRulerPanel;
import com.kingnare.skins.frames.TimeLinePanel;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.FileListEvent;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.FileFilter;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import flash.utils.CompressionAlgorithm;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import mcyy.imgcode.Png8Encoder;
import mcyy.loader.fanim.FamFileWrite;
import mcyy.loader.fanim.FanimDisplay;
import mcyy.loader.fanim.FanmFileInfo;
import mcyy.scene.ShadowAsset;
import mcyy.utils.BatImplFrameInfoHandler;
import mcyy.utils.BitmapUtils;
import mcyy.utils.FileUtils;
import mcyy.utils.SingleFramePNG2FamHandler;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.ProgressBar;
import mx.controls.ProgressBarMode;
import mx.core.Application;
import mx.graphics.codec.JPEGEncoder;
import mx.managers.PopUpManager;

import publicutil.PublicUtil;
import publicutil.SWFParser;

import spark.core.SpriteVisualElement;

private var _finish:int =0;
private var _actions:Dictionary
private var _to:Array;
private var _paths:Array;

//
///*
//DWORD 	dwMagic;		// 'FANM'
//WORD	wVersion;		// 1
//WORD	wFrameCnt;		// 帧数
//
//struct FrameInfo
//{
//int		imgOffset;		// 数据开始偏移
//int		imgDataTotal;	// 图像数据(含alpha)总大小
//int		jpegDataSz;		// 图像数据字节数
//short cx;			// 中心点
//short cy;
//short w;			// 宽高
//short h;
////	int		alphaDataSz;	// alpha数据字节数	= imgDataTotal - jpegDataSz
//}
//
//imageData[];
//*/
//private var _fanmFrmList:Array = [];
//


private var _lastNativePath:String;
private var _pF:FanmFileInfo;

private var _dispSpr:SpriteVisualElement;
private var _lastOpenFamInfo:FanmFileInfo =  new FanmFileInfo();
private var _fanimDisplay:FanimDisplay = new FanimDisplay();
private var _timeLinePanel:TimeLinePanel;		// 时间轴
private var _rulerPanel:ScaleRulerPanel;		// 刻度面板
private var _selectedFrameIdx:int = -1;			// 当前选择的帧索引

private function onCreate():void
{
	registerClassAlias("flash.utils.Dictionary",Dictionary);
	registerClassAlias("Array",Array);
	registerClassAlias("mcyy.loader.fanim.FanmFileInfo",FanmFileInfo);
	
	_lastNativePath = File.applicationStorageDirectory.nativePath;	//clp20120421 采用当前登录用户的APP保存路径// "C:\Users\Administrator\Desktop";
	
	reviseSavePath.text =_lastNativePath;
	
	_dispSpr = new SpriteVisualElement();                
	pnlOpen.addElement(_dispSpr);

	_fanimDisplay.y = 60;
	_dispSpr.addChild( _fanimDisplay );
	
	_timeLinePanel = new TimeLinePanel(_fanimDisplay);
	_timeLinePanel.y = 380;
	_dispSpr.addChild(_timeLinePanel);
	_rulerPanel = _timeLinePanel.rulerPanel;
	_fanimDisplay.registerRulerPanel(_rulerPanel);
	_rulerPanel.addEventListener(Event.SELECT, onSelectFrameHandler);
	_rulerPanel.addEventListener(Event.CHANGE, onRulerDataChangedHandler);
//	Application.application.status = "Hello World.";
	
	_fanimDisplay.beginPlayNotifyFunc = onFamFileLoadUpdateUI;
	
	this.addEventListener( Event.ENTER_FRAME , handleEnterFrame );
	this.addEventListener( MouseEvent.MOUSE_MOVE , handleMouseMove );
	
	addEventListener( MouseEvent.CLICK , handleFamShowPanelClick );
	
//	var timer:Timer = new Timer(100, int.MAX_VALUE);
//	timer.addEventListener(TimerEvent.TIMER, loadFamTest);
//	timer.start();
//	count = 0;
}

////----wangq
public static var count:int;
private function loadFamTest(d:* = null):void
{
	// 加载文件
	
	trace("start Time == " + getTimer());
	for (var i:int = 0; i < 2; ++i)
	{
//		var urlLoader:URLLoader = new URLLoader();
//		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
//		urlLoader.addEventListener(Event.COMPLETE, this.famLoadCompleteHandler);
//		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.famIoErrorHandler);
//		urlLoader.load( new URLRequest( "E:/assets/mcFlashClient/webassets/assets/img/se/skill03/bpjc02_7.fam" ));/// "C:/Users/Administrator/Desktop/swfTest/image_jpeg_7.fam" ) );
		
//		var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
//		var loader:Loader = new Loader();
//		loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressTest);
//		loader.contentLoaderInfo.addEventListener(Event.UNLOAD, onUnLoadTest);
//		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteTest);
//		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorTest);
//		loader.load(new URLRequest("C:/Users/Administrator/Desktop/6.swf"), loaderContext);
	}
}


private function onCompleteTest(e:Event = null):void
{
	trace("got it");
	
	var movie:MovieClip = (e.target as LoaderInfo).content as MovieClip;
//	movie.play();
//	var obj:DisplayObject = (movie/*.getChildAt(0) as DisplayObjectContainer*/).getChildAt(0);
//	obj.x = 100;
//	obj.y = 100;
//	_dispSpr.addChild(obj);
	
//	var cls:Class;
//	try
//	{
//		cls = (e.target as LoaderInfo).applicationDomain.getDefinition("f.dfs_73") as Class;
//	}
//	catch (rrr:Error)
//	{
//		trace("error");
//	}
//	
//	if (cls)
//	{
//		var a:BitmapData = new cls();
//		var bitmap:Bitmap = new Bitmap(a);
//		bitmap.x = 100;
//		bitmap.y = 100;
//		_dispSpr.addChild(bitmap);
//	}
//	
//	var swfClass:Array = SWFParser.parseClassName((e.target as LoaderInfo).bytes);
}

private function onIOErrorTest(e:* = null):void
{
	trace("got it 1111");
}

private function onProgressTest(e:ProgressEvent):void
{
//	trace("onProgressTest  ===    " + e.bytesLoaded + "     " + e.bytesTotal);
}

private function onUnLoadTest(e:Event):void
{
	trace("got it 2222");
}

private function onSelectFrameHandler(e:Event):void
{
	_selectedFrameIdx = _rulerPanel.getSelectedIndex();
	_fanimDisplay.selectIdx = _rulerPanel.displayIndex2FramesIndex(_selectedFrameIdx);
}

private function onRulerDataChangedHandler(e:Event):void
{
	_fanimDisplay.modifyFlag = true;
	saveAsFam.enabled = true;
}

// 鼠标点击消息处理
private function handleFamShowPanelClick( evt:MouseEvent ):void
{
	//if( evt.target==tabMain )
	{
		if( true
			&& (tabMain.selectedIndex==1)												// 选中打开页
			&& famShowPanel.mouseX>=0 && famShowPanel.mouseX<famShowPanel.width
			&& famShowPanel.mouseY>=0 && famShowPanel.mouseY<famShowPanel.height		// 在显示区域内
			&& _fanimDisplay && _fanimDisplay.isPlaying									// 已打开
			&& evt.controlKey==true														// 且按住CTRL
		)
		{
			//var strText:String = famShowPanel.mouseX + " " + famShowPanel.mouseY;	//evt.localX + " " + evt.localY;
			//trace( strText );
			if( _fanimDisplay.info.ox != famShowPanel.mouseX
				&& famShowPanel.mouseY != _fanimDisplay.info.oy )
			{
				_fanimDisplay.setOxy( famShowPanel.mouseX , famShowPanel.mouseY );
				famOx.text = String( _fanimDisplay.info.ox );
				famOy.text = String( _fanimDisplay.info.oy );
				
				if( _fanimDisplay.modifyFlag )
				{
					saveAsFam.enabled = true;
				}
				
			}
		}
	}
}

private function handleEnterFrame( evt:Event ):void
{
	// do nothing
	//Application.application.status = "EnterFrame.";
}

// 鼠标移动消息处理,主要为了显示当前鼠标坐标
private function handleMouseMove( evt:MouseEvent ):void
{
	//Application.application.status = "Mouse Move.";
	var strText:String = famShowPanel.mouseX + " " + famShowPanel.mouseY;
	Application.application.status = strText;
}

// 暂停播放键
private function pausePlayClick( evt:Event ):void
{
	if( _fanimDisplay )
	{
		_fanimDisplay.stopAtEnd = false;
		_fanimDisplay.paused =  false;
	}
}

private function playOnceClick(evt:Event):void
{
	if (_fanimDisplay)
	{
		_fanimDisplay.stopAtEnd = true;
		_fanimDisplay.paused = false;
		_fanimDisplay.reinitPlayFrames();
		_fanimDisplay.dirLock = -1;
	}
	
	if (_rulerPanel)
		_rulerPanel.updateFrameValue();
}

private function onFrameRateChanged(evt:Event):void
{
	if (_fanimDisplay)
	{
		_fanimDisplay.updateFrameRate(parseInt(frameRateText.text, 10));
	}
}

private function onTimeLineScrollChanged(evt:Event):void
{
	_timeLinePanel.updateScrollValue(timeLineScrollBar.value / timeLineScrollBar.maximum);
}

private function addFrameBtnClick(e:MouseEvent):void
{
	if (_rulerPanel && _fanimDisplay && _fanimDisplay.selectIdx != -1)
	{
		if (_rulerPanel.addFrame())
		{
			if( _fanimDisplay.modifyFlag )
			{
				saveAsFam.enabled = true;
			}
		}
	}
}

private function removeFrameBtnClick(e:MouseEvent):void
{
	if (_rulerPanel && _fanimDisplay && _fanimDisplay.selectIdx != -1)
	{
		if (_rulerPanel.removeFrame())
		{
			if( _fanimDisplay.modifyFlag )
			{
				saveAsFam.enabled = true;
			}
		}
	}
}

private function onDirect5CheckBoxChanged(e:Event):void
{
	if (_lastOpenFamInfo)
	{
		if (direct5CheckBox.selected && (_lastOpenFamInfo.frames.length % 5 != 0))
		{
			direct5CheckBox.selected = false;
			Alert.show("帧长度必须是5倍数才能选择5方向。","error");
			return;
		}
		
		_lastOpenFamInfo.isDirect5 = direct5CheckBox.selected;
		if (!_lastOpenFamInfo.isDirect5)
		{
			if (_fanimDisplay)
			{
				_fanimDisplay.dirLock = -1;
			}
			if (_rulerPanel)
				_rulerPanel.updateFrameValue();
		}
		
		saveAsFam.enabled = true;
	}
}

private function onList5DirectChanged(e:Event):void
{
	listNot5DirectBox.selected = !list5DirectBox.selected;
}

private function onListNot5DirectChanged(e:Event):void
{
	list5DirectBox.selected = !listNot5DirectBox.selected;
}

private function onCreateCompressSelectChanged(e:Event):void
{
	
}

private function onOpenCompressSelectChanged(e:Event):void
{
	if (_fanimDisplay && _fanimDisplay.info)
	{
		_fanimDisplay.info.isCompress = openCompressCB.selected;
	}
}

private function onopenShowShadowSelectChanged(e:Event):void
{
	if (_fanimDisplay)
		_fanimDisplay.showShadow(openShowShadow.selected);
}

// 缩放比修改
private function famScale_changeHandler( evt:Event ):void
{
	var scaleRatio:Number = Number( famScale.text );
	if( _fanimDisplay )
	{
		_fanimDisplay.famScale =  scaleRatio ;
	}
	
}

// 打开fam
private function openFileClick( evt:Event ) : void
{
	var dir:File = new File();
	if( famFileName.text )
	{
		dir.nativePath = famFileName.text ;
	}
	
	dir.browseForOpen( "打开fam文件" );
	dir.addEventListener(Event.SELECT,  openFileSelected);
}

private function openFileSelected(e:Event):void
{
	var file:File = File(e.target);
	this.famFileName;
	famFileName.text = file.nativePath;
	
	// 加载文件
	var urlLoader:URLLoader = new URLLoader();
	urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
	urlLoader.addEventListener(Event.COMPLETE, this.famLoadCompleteHandler);
	urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.famIoErrorHandler);
	urlLoader.load( new URLRequest( file.nativePath ) );
}

private function famLoadCompleteHandler( event:Event ) : void
{
	var urlLoader:URLLoader = URLLoader( event.target );
	//urlLoader.data
	_lastOpenFamInfo.datas = urlLoader.data;
	if( !_lastOpenFamInfo.count )
	{
		// 没有文件帧,出错
		Alert.show("打开fam文件错误,可能是文件格式错误!");
		return;
	}
	
	_fanimDisplay.modifyFlag = false;
	_fanimDisplay.loadFromFileInfo( _lastOpenFamInfo );
	
	_rulerPanel.loadFromFileInfo(_lastOpenFamInfo);
	
	direct5CheckBox.selected = _lastOpenFamInfo.isDirect5;
	FamRevisionText.text = String(_lastOpenFamInfo.revision);
}

private function famIoErrorHandler( event:IOErrorEvent ) : void
{
	Alert.show("打开fam文件错误");
}

// 另存为修改后的fam
private function famSaveAsClick( evt:Event ):void
{
	if( !_fanimDisplay )
		return;
	
	if( !_fanimDisplay.isPlaying )
	{
		Alert.show("fam未打开?");
		return;
	}
	
	if( !_fanimDisplay.modifyFlag )
	{
		Alert.show("fam没有改变!");
		return;
	}
	var dir:File = new File();
	if( famFileName.text )
	{
		dir.nativePath = famFileName.text ;
	}
	
	dir.browseForSave( "另存fam文件为" );
	dir.addEventListener(Event.SELECT,  saveAsFamSelected);
}

private function saveAsFamSelected(e:Event):void
{
	var file:File = File(e.target);
	
	var famFn:String = file.nativePath;
	
	// 保存文件
	if( !_fanimDisplay || !_fanimDisplay.modifyFlag )
		return;
	
	FamFileWrite.writeFamFile( _fanimDisplay.info , famFn );
	_fanimDisplay.modifyFlag = false;
	
	if( _fanimDisplay.modifyFlag )
	{
		saveAsFam.enabled = true;
	}
}


public function onFamFileLoadUpdateUI( fam:FanimDisplay ):void
{
	famOx.text = String( fam.info.ox );
	famOy.text = String( fam.info.oy );
	
	famFrameType.selectedIndex = fam.info.frameType-1;
	famComptype.selectedIndex = fam.info.compType;
	
	frameRateText.text = String(fam.info.frameRate);
}

private function selectFilesClick(e:Event):void
{
	var dir:File = new File();
	if( pngSrcPath.text )
	{
		dir.nativePath = pngSrcPath.text ;
	}
	dir.browseForDirectory("选择PNG文件夹");
	dir.addEventListener(Event.SELECT,  dirSelect);	
}
private function compTypeChange(e:Event):void
{
	quality.visible = (comptype.selectedIndex == 0);
}

private function famFrameTypeChange( evt:Event ):void
{
	if( _fanimDisplay )
	{
		_fanimDisplay.frameType = famFrameType.selectedIndex+1 ;
		if( _fanimDisplay.modifyFlag )
		{
			saveAsFam.enabled = true;
		}
	}
	
	if (_rulerPanel)
		_rulerPanel.updateFrameValue();
}

private function famOxy_changeHandler( evt:Event ):void
{
	var cx:int = int(famOx.text);
	var cy:int = int(famOy.text);
	
	if( _fanimDisplay )
	{
		_fanimDisplay.setOxy( cx , cy );
		if( _fanimDisplay.modifyFlag )
		{
			saveAsFam.enabled = true;
		}
	}
}

private function fileResurveBoxSelectChanged(e:Event):void
{
	_fileResurve = fileResurveBox.selected;
}

private var _fileResurve:Boolean = false;	// 是否递归地寻找出所有需要转换的目录
private var _allPathFiles:Array = [];		// 
private var _currentResurveFile:File;
private var _selectFile:File;
private function dirSelect(e:Event):void
{
	_selectFile = File(e.target);
	if (_fileResurve)
	{
		_allPathFiles = [];
		FileUtils.getAllSpecificFilesParentDirectory(_selectFile, _allPathFiles, ".png");
		
		_lastNativePath = _selectFile.nativePath;
		pngSrcPath.text = _lastNativePath;
		startRevise.enabled = _allPathFiles.length > 0;
	}
	else
	{
		doCalcPNGPath(_selectFile);
	}
}

private function doCalcPNGPath(file:File, resurve:Boolean = true):void
{
	_paths = [];
	
	var iDirNum:int = 0;						// 子目录数
	var iRootDirFile:int = 0;					// 选中目录文件数
	if(file.isDirectory)
	{
		_lastNativePath = file.nativePath;
		pngSrcPath.text = _lastNativePath;
		for each(var item:File in file.getDirectoryListing())
		{
			if(item.isDirectory && resurve)
			{
				var isEmpty:Boolean = true;
				for each(var item1:File in item.getDirectoryListing())
				{
					if(item1.name.search(/\.png/) != -1)
					{
						_paths.push(item1.nativePath);
						isEmpty = false;
					}
				}
				if( !isEmpty )
				{
					++iDirNum;
				}
			}
			if(item.name.search(/\.png/) != -1)
			{
				_paths.push( item.nativePath );
				++iRootDirFile;
			}
		}
		_paths.sort();		
		
		if(_paths.length>0)
		{
			if( iRootDirFile>0 )
				++iDirNum;
			
			startRevise.enabled = true;
			tips.htmlText = "总共选择了"+ _paths.length + "个文件" + "  " + iDirNum + "个动作";
			return;
		}
		else
		{
			startRevise.enabled = false;
		}
	}		
	tips.htmlText = "<font color='#990000'>请选择文件</font>";
}


private function compSelectPathClick(e:Event):void
{
	var dir:File = new File();
	dir.nativePath = reviseSavePath.text;//"D:/";
	dir.browseForDirectory("选择保存路径");
	dir.addEventListener(Event.SELECT,  reviseSaveSelected);
}


private function reviseSaveSelected(e:Event):void
{
	reviseSavePath.text = File(e.target).nativePath as String;
}

/**
 * 开始打包
 * @param e
 * 
 */
private function compBtnClick(e:Event):void
{
	pnlCreate.mouseChildren = pnlCreate.mouseEnabled = false;
	if (_fileResurve)
	{
		handleNextFam();
	}
	else
	{
		startPackageToFam();
	}
}

private function handleNextFam():void
{
	if (!_allPathFiles || (_allPathFiles.length == 0))
	{
		// 结束
		pnlCreate.mouseChildren = pnlCreate.mouseEnabled = true;
		barCan.visible = false;	
		Alert.show("打包完成");
		return;
	}
	
	var path:String = _allPathFiles.shift();
	_currentResurveFile = new File(path);
	this.doCalcPNGPath(_currentResurveFile, false);
	startPackageToFam();
}

private function startPackageToFam():void
{
	//显示进度条
	barCan.visible = true;	
	
	_finish = 0;
	
	if(_paths.length == 0)
	{
		Alert.show("请选择文件");
		return;
	}
	
	_pF = new FanmFileInfo;
	_pF.count = _paths.length;
	_pF.compType = comptype.selectedIndex;
	_pF.frameType = frameType.selectedIndex + 1;
	_pF.ox = int(ox.text);
	_pF.oy = int(oy.text);
	_pF.isContainAlpha = containAlpha.selected ? 0 : 1;
	_pF.isDirect5 = direct5CreateBox.selected;
	_pF.frameRate = parseInt(frameRateCreateText.text, 10);
	_pF.isCompress = compressCheckBox.selected;
	
	var i:int = 0;
	var dic:Dictionary = new Dictionary;
	for each (var path:String in _paths)
	{
		//if(comptype.selectedIndex == 0)
		{
			var pngLoader:ImageLoader = new ImageLoader( path,i);
			pngLoader.addEventListener(ImageLoader.COMPLETE, onComplete);
			pngLoader.addEventListener(ImageLoader.ERROR, onError);
			dic[i] = {loader:pngLoader,timer:Math.random() *10000 };
		}
		/*else
		{
			var pngLoader1:PngLoader = new PngLoader( path,i);
			pngLoader1.addEventListener(ImageLoader.COMPLETE, onPngComplete);
			pngLoader1.addEventListener(ImageLoader.ERROR, onError);
			dic[i] = {loader:pngLoader1,timer:Math.random() *10000 };
		}*/
		
		i++;
	}
	for each( var obj:Object in dic)
	{
		setTimeout(obj.loader.load,obj.timer);
	}
	
}



private function anyName(content:String):String
{
	var pattern:RegExp = /(ridle|rmove|atk1|atk2|cast2|cast|die|gat|idlefight|run|idle|walk|hit)/ig;
	var array:Array = pattern.exec(content.toLowerCase()) as Array;
	if(array == null || array.length < 2)		//限制
		return "null";
	var action:String = "null";
	if(array[1] != undefined ){
		return getPos( array[1].toString());
	}
	return "null";
}


private function getPos(pos:String):String{
	var ret:String;
	switch(pos){
		case "idle":
			ret = "1";
			break;
		case "run":
			ret = "2";
			break;
		case "cast":
			ret = "4";
			break;
		case "atk1":
			ret = "5";
			break;
		case "hit":
			ret = "6";
			break;
		case "die":
			ret = "7";
			break;
		case "ridle":
			ret = "8";
			break;
		case "rmove":
			ret = "9";
			break;
		case "idlefight":
			ret = "10";
			break;
		case "atk2":
			ret = "11";
			break;
		case "cast2":
			ret = "12";
			break;
		case "gat":
			ret = "13";
			break;
		case "walk":
			ret = "3";
			break;
	}
	return ret;
}



private function onError(evt:Event):void {
	var pngLoader:ImageLoader = evt.target as ImageLoader;
	Alert.show("序列"+pngLoader.seq+"的文件加载出错了");
}

private function onError1(evt:Event):void {
	var pngLoader:PngLoader = evt.target as PngLoader;
	Alert.show("序列"+pngLoader.seq+"的文件加载出错了");
}

private function onComplete(evt:Event):void
{
	var pngLoader:ImageLoader = evt.target as ImageLoader;
	var newObj:Object = BitmapUtils.handleBitmapData(pngLoader.bitmapData, !clipCheck.selected, int(ox.text), int(oy.text));
	createFanmText.text = pngLoader.url;
	
	if( _pF.compType==1 )
	{
		// png8
		var png8Encoder:Png8Encoder = new Png8Encoder();
		png8Encoder.addEventListener(ImageLoader.COMPLETE, onPng8Complete);
		png8Encoder.addEventListener(ImageLoader.ERROR, onError);
		
		png8Encoder.encode( newObj.bitmapData , pngLoader.seq , newObj.cx , newObj.cy , newObj.rw , newObj.rh );
		return;
	}
	
	// jpeg Alpha
	bar.setProgress(_finish,_paths.length);
	var jpegTag:Object = BitmapUtils.addImageAssets(newObj.bitmapData,int(quality.text));
	_pF.bitmapDatas[pngLoader.seq] = jpegTag;
	
	
	_pF.offsets[pngLoader.seq] = { cx:newObj.cx , cy:newObj.cy , rw:newObj.rw , rh:newObj.rh };
	
	_finish++;
	trace(_finish,_paths.length);
	if(_finish >= _paths.length)
	{
		writeMcyyFAnmFiles();
	}
}

private function onPng8Complete( evt:Event ):void
{
	bar.setProgress(_finish,_paths.length);
	var png8Encoder:Png8Encoder = evt.target as Png8Encoder;
	
	_pF.bitmapDatas[png8Encoder.seq] = png8Encoder.bitmapData;
	
	_pF.offsets[png8Encoder.seq] = { cx: png8Encoder.cx , cy: png8Encoder.cy , rw:png8Encoder.rw , rh:png8Encoder.rh };
	
	_finish++;
	trace(_finish,_paths.length);
	if(_finish >= _paths.length)
	{
		writeMcyyFAnmFiles();
	}
	
}


private function onPngComplete(evt:Event):void
{
	bar.setProgress(_finish,_paths.length);
	var pngLoader:PngLoader = evt.target as PngLoader;
		
	_pF.bitmapDatas[pngLoader.seq] = pngLoader.bitmapData;
	
	_pF.offsets[pngLoader.seq] = { cx:  int(ox.text) , cy: int(oy.text) , rw:100 , rh:100 };
	
	_finish++;
	trace(_finish,_paths.length);
	if(_finish >= _paths.length)
	{
		writeMcyyFAnmFiles();
	}
}


private function addImageAssets(bmp:BitmapData,quality:int = 80):Object
{
	var jpg:JPEGEncoder = new JPEGEncoder(quality);
	return {alphaData:getAlphapixels(bmp.getPixels(bmp.rect)),jpegData: jpg.encode(bmp)};
}


private function getAlphapixels(pixels:ByteArray):ByteArray{
	var data1:ByteArray = new ByteArray;
	var i:int = 0;
	while(i< pixels.length){
		var alpha:int = (pixels[i]) ; 
		data1.writeByte(alpha); 
		i = i+4;
	}
	data1.compress();
	return data1;
}

private function writeMcyyFAnmFiles() : void
{
	_actions = new Dictionary;
	
	var action:String = "null";
	var j:int = 0;
	for (var i:int = 0 ; i< _paths.length ; ++i)
	{
		var newaction:String ;
		
		if(getnametype.selected)
		{
			newaction = getRootName(_paths[i]);
			
		}
		else
		{
			newaction = anyName(_paths[i]);
		}
		if(i == 0)
		{
			action = newaction;
		}
		if(action != newaction )
		{
			_actions[action] = {s:j,e:i-1};
			j = i;
			action = newaction;
		}
	}
	if (this._fileResurve && _currentResurveFile)
	{
		action = _currentResurveFile.name;
	}
	
	_actions[action] = {s:j,e:i-1};
	
	for (var obj:Object in _actions)
	{
		var pF:FanmFileInfo = new FanmFileInfo;
		pF.action = int(obj);
		pF.count = _actions[obj].e - _actions[obj].s + 1;
		pF.compType = _pF.compType;
		pF.frameType = _pF.frameType;
		pF.ox = _pF.ox;
		pF.oy = _pF.oy;
		pF.isContainAlpha = _pF.isContainAlpha;
		pF.frameRate = _pF.frameRate;
		pF.frames = _pF.frames;
		pF.isDirect5 = _pF.isDirect5;
		pF.isCompress = _pF.isCompress;
		
		var k:int = 0;
		for(var h:int = _actions[obj].s ; h <= _actions[obj].e ; ++h)
		{
			pF.bitmapDatas[k] = _pF.bitmapDatas[h];
			pF.offsets[k] = _pF.offsets[h];
			k++;
		}
		var fullFn:String = reviseSavePath.text +"\\" + obj.toString() +".fam" ;
		if (this._fileResurve && _currentResurveFile && _selectFile)
		{
			var relativePath:String = _selectFile.getRelativePath(_currentResurveFile);
			var targetFile:File = new File(reviseSavePath.text);
			var writeDirectory:File = targetFile.resolvePath(relativePath).parent;
			var writeFile:File = new File(writeDirectory.nativePath +"\\" + obj.toString() +".fam");
			fullFn = writeFile.nativePath;
		}
		
		FamFileWrite.writeFamFile( pF , fullFn );
		pF = null;
	}
	
	if (_fileResurve)
	{
		this.handleNextFam();
	}
	else
	{
		pnlCreate.mouseChildren = pnlCreate.mouseEnabled = true;
		barCan.visible = false;	
		createFanmText.text = "";
		Alert.show("打包完成");
	}
}

/*private function writeFamFile(pF:FanmFileInfo,filename:String):void
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
	for( var iFrm:uint=0; iFrm<pF.count; ++iFrm )
	{
		var fanmFrameObj:Object = pF.bitmapDatas[iFrm];	// 取出当前帧数据
		var frmIdx:int = iFrm;

		var dataJpeg:ByteArray = null;
		var dataAlpha:ByteArray = null;
		if( FanmFileInfo.COMPTYPE_JPEGALPHA == pF.compType )
		{
			// jpegAlpha
			dataJpeg = fanmFrameObj.jpegData;
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
	
	// OK,fdata为文件数据
	
	//fdata.writeObject(pF);
	
	var swfStream:FileStream = new FileStream();
		
	swfStream.open( new File( filename ) , FileMode.WRITE);
	
	swfStream.writeBytes(fdata);
	
	swfStream.close();
	swfStream = null;
}
*/

private function handleBitmapData(bitmapData:BitmapData, clip:Boolean, cX:int, cY:int):Object
{
	// 如果选择不裁剪，直接返回原图数据
	if (!clip)
	{
		return {cx: int(ox.text), cy: int(oy.text), rw:bitmapData.width, rh:bitmapData.height, bitmapData: bitmapData};
	}
	
	var x_min:int=bitmapData.width;
	var x_max:int=0;
	var y_min:int=bitmapData.height;
	var y_max:int=0;
	
	var value:uint = 0;
	for(var j:int=0; j<bitmapData.height; j++)
	{
		var temp:int = 0;
		for(var i:int=0; i<bitmapData.width; i++)
		{
			value = bitmapData.getPixel32(i, j);
			if(value>0)
			{
				if(i<x_min){
					x_min = i;
				}
				else if(i>x_max){
					x_max = i;
				}
				if(j<y_min){
					y_min = j;
				}
				else if(j>y_max){
					y_max = j;
				}
			}
		}
	}
	var cx:int = int(ox.text) - x_min;
	var cy:int = int(oy.text) - y_min;
	
	var rw:int = x_max - x_min+1;
	var rh:int = y_max - y_min+1;
	if(rw<0 || rh<0){
		rw = 10;
		rh = 10;
		x_min = 0;
		y_min = 0;
	}
	
	var newBitmapData:BitmapData = new BitmapData(rw, rh);
	newBitmapData.copyPixels(bitmapData, new Rectangle(x_min, y_min, rw, rh), new Point(0,0));
	
	return {cx: cx, cy: cy, rw:rw, rh:rh, bitmapData: newBitmapData};
}


private function getRootName(path:String):String
{
	var list:Array = path.split("\\");
	list.pop();
	//var list1:Array = list[0].split("\\");
//	list.pop();
	var retStr:String = list.pop();
	retStr = retStr.toLowerCase();
	return retStr;
}

/////////////////////////////////////////  批量帧频转换

private var _inputDir:File;		// 输入输出目录
private var _outputDir:File;

private var _filtersList:Array;	// 文件过滤列表
private var _progress:ProgressBar = new ProgressBar();	// 批量处理的进度显示

private var _batImplHandler:BatImplFrameInfoHandler;	// 批量处理器

private function onFrameInputBtnClick(e:MouseEvent):void
{
	var dir:File = File.desktopDirectory.resolvePath("");
	dir.browseForDirectory( "选择批量处理文件夹" );
	dir.addEventListener(Event.SELECT,  openInputBatDicSelected);
}

private function onFrameOutputBtnClick(e:MouseEvent):void
{
	var dir:File = File.desktopDirectory.resolvePath("");
	dir.browseForDirectory( "选择导出文件夹" );
	dir.addEventListener(Event.SELECT,  openOutputBatDicSelected);
}

private function openInputBatDicSelected(e:Event):void
{
	_inputDir = e.target as File;
	frameInputText.text = _inputDir ? _inputDir.nativePath : "";
}

private function openOutputBatDicSelected(e:Event):void
{
	_outputDir = e.target as File;
	frameOutputText.text = _outputDir ? _outputDir.nativePath : "";
}

private function inputTextChanged(e:Event):void
{
}

private function outputTextChanged(e:Event):void
{
}

private function onFrameBatImplClick(e:MouseEvent):void
{
	if (!_inputDir)
		_inputDir = File.desktopDirectory.resolvePath(frameInputText.text);
	if (!_outputDir)
		_outputDir = File.desktopDirectory.resolvePath(frameOutputText.text);
	
	if ((!frameInputText.text) || (!frameOutputText.text) || (!_inputDir.exists) || (!_outputDir.spaceAvailable))
	{
		Alert.show("未选择输入目录或输出目录。", "批量应用错误");
		return;
	}
	
	frameListTextArea.text = "";
	var isList5Direct:Boolean = list5DirectBox.selected;
	
	_batImplHandler = new BatImplFrameInfoHandler(_inputDir, _outputDir, _filtersList, famFrameType.selectedIndex+1, parseInt(frameRateText.text, 10), isList5Direct, justUpdateFamBox.selected);
	_batImplHandler.addEventListener(Event.CHANGE, onBatHandleChanged);
	_batImplHandler.addEventListener(Event.COMPLETE, onBatHandleCompleted);
	_batImplHandler.addEventListener(Event.SELECT, onBatHandleSelected);
	_batImplHandler.start();
	
	_progress.mode = ProgressBarMode.MANUAL;
	_progress.setProgress(0, 1);
	_progress.x = (this.width - _progress.width) * 0.5;
	_progress.y = (this.height - _progress.height) * 0.5;
	PopUpManager.addPopUp(_progress, this, true);
}

private function onBatHandleChanged(e:Event):void
{
	_progress.setProgress(_batImplHandler.handledCount, _batImplHandler.totalCount);
}

private function onBatHandleCompleted(e:Event):void
{
	PopUpManager.removePopUp(_progress);
}

private function onBatHandleSelected(e:Event):void
{
	var currFile:File = _batImplHandler.currentFamFile;
	if (currFile)
	{
		frameListTextArea.appendText(_inputDir.getRelativePath(currFile) + "\r\n");
	}
}

private function onFrameFilterAddBtnClick(e:MouseEvent):void
{
	var filterStr:String = frameFilterText.text;
	if (!filterStr)
		return;
	
	if (!_filtersList)
		_filtersList = [filterStr];
	else
	{
		if (_filtersList.indexOf(filterStr) == -1)
			_filtersList.push(filterStr);
	}
	
	updateFilterDisplay();
}

private function onFrameFilterRemoveBtnClick(e:MouseEvent):void
{
	var filterStr:String = frameFilterText.text;
	if (!filterStr)
		return;
	
	if (!_filtersList)
		return;
	else
	{
		var index:int = _filtersList.indexOf(filterStr);
		if (index > -1)
			_filtersList.splice(index, 1);
	}
	
	updateFilterDisplay();
}

private function updateFilterDisplay():void
{
	frameFilterList.dataProvider = new ArrayCollection(_filtersList);
}


//////////////////////////////////////////// 批量单帧png转fam

private var _singlePNGFiles:Array;
private var _inputDic:File;
private var _outputDic:File;

private var _png2famHandler:SingleFramePNG2FamHandler;

private function singleFileRadioClick(e:Event):void
{
	singleDictionaryRadio.selected = !singleFileRadio.selected;
	updateMode();
}

private function singleDicRadioClick(e:Event):void
{
	singleFileRadio.selected = !singleDictionaryRadio.selected;
	updateMode();
}

private function updateMode():void
{
	singleFileBtn.enabled = singleFileRadio.selected;
	singleInputFileText.text = singleFileRadio.selected ? singleInputFileText.text : "";
	_inputDic = singleFileRadio.selected ? null : _inputDic;
	singleDicBtn.enabled = !singleFileRadio.selected;
	singleInputDicText.text = singleFileRadio.selected ? "" : singleInputDicText.text;
	_singlePNGFiles = null;
}

private function selectSingleMultiFileHandler(e:Event):void
{
	var file:File = File.desktopDirectory.resolvePath("");
	file.browseForOpenMultiple("选择需要转换的png文件", [new FileFilter("png图片(*.png)", "*.png")]);
	file.addEventListener(FileListEvent.SELECT_MULTIPLE, onSingleMultiFileSelected);
}

private function selectSingleInputDictionary(e:Event):void
{
	var file:File = File.desktopDirectory.resolvePath("");
	file.browseForDirectory("选择需要转换的png文件夹");
	file.addEventListener(Event.SELECT, onSingleDictionarySelected);
}

private function onSingleDictionarySelected(e:Event):void
{
	_inputDic = File(e.target);
	singleInputDicText.text = _inputDic.nativePath;
	
	// 生成所有需要转换的png文件
	_singlePNGFiles = [];
	FileUtils.getAllSpecificFiles(_inputDic, _singlePNGFiles, ".png");
}

private function selectSingleOutputDictionary(e:Event):void
{
	var file:File = File.desktopDirectory.resolvePath("");
	file.browseForDirectory("选择输出目录");
	file.addEventListener(Event.SELECT, onSingleDictionaryOutputSelected);
}

private function onSingleDictionaryOutputSelected(e:Event):void
{
	_outputDic = File(e.target);
	singleOutputText.text = _outputDic.nativePath;
}

private function onSingleMultiFileSelected(e:FileListEvent):void
{
	trace(e.type);
	_singlePNGFiles = e.files;
	updateFilesText();
}

private function updateFilesText():void
{
	var filesText:String = "";
	var length:int = _singlePNGFiles.length;
	for (var i:int = 0; i < length; ++i)
	{
		var file:File = _singlePNGFiles[i];
		if (file)
			filesText += file.name + "; ";
	}
	
	singleInputFileText.text = filesText;
}

private function startSinglePackage(e:Event):void
{
	if (!_singlePNGFiles || !_outputDic)
	{
		Alert.show("请选择输入和输出信息。","error");
		return;
	}
	
	_progress.mode = ProgressBarMode.MANUAL;
	_progress.setProgress(0, 1);
	_progress.x = (this.width - _progress.width) * 0.5;
	_progress.y = (this.height - _progress.height) * 0.5;
	PopUpManager.addPopUp(_progress, this, true);
	
	var pf:FanmFileInfo = new FanmFileInfo();
	pf.ox = int(singleox.text);
	pf.oy = int(singleoy.text);
	pf.isCompress = singleCompressCheckBox.selected;
	pf.isContainAlpha = singlecontainAlpha.selected ? 0 : 1;
	_png2famHandler = new SingleFramePNG2FamHandler(_singlePNGFiles.concat(), pf, _inputDic, _outputDic, !singleclipCheck.selected, int(singleQuality.text));  
	_png2famHandler.addEventListener(Event.CHANGE, onSinglePNGHandleChanged);
	_png2famHandler.addEventListener(Event.COMPLETE, onSinglePNGHandleCompleted);
	_png2famHandler.start();
}

private function onSinglePNGHandleChanged(e:Event):void
{
	_progress.setProgress(_png2famHandler.handledCount, _png2famHandler.totalCount);
}

private function onSinglePNGHandleCompleted(e:Event):void
{
	PopUpManager.removePopUp(_progress);
}


//
//
//
//
//
