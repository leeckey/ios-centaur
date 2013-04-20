package com.kingnare.skins.frames
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mcyy.loader.fanim.FanmFileInfo;
	
	import mx.controls.Alert;

	/**
	 *   刻度标尺面板
	 *   @author wangq 2012.09.27
	 */ 
	public final class ScaleRulerPanel extends Sprite
	{
		public static const RULER_LENGTH:int = 200;
		public static const SEGMENT_WIDTH:int = 13;
		public static const SEGMENT_HEIGHT:int = 30;
		
		// 时间轴面板,存引用
		public var timeLinePanel:TimeLinePanel;
		
		// 被选中时的形状
		private static var _selectShape:Shape;
		
		// 时间轴帧列表
		private var _frameTextList:Array = new Array(RULER_LENGTH);
		
		// 当前被选择的一帧
		private var _selectedIndex:int = -1;
		
		// 当前FANM文件的数据信息
		private var _fanmFileInfo:FanmFileInfo;
		
		public function ScaleRulerPanel()
		{
			setup();
		}
		
		public function loadFromFileInfo(fileInfo:FanmFileInfo):void
		{
			_fanmFileInfo = fileInfo;
			
			// 更新帧显示
			updateFrameValue();
		}
		
		public function updateFrameValue():void
		{
			var frameList:Array = _fanmFileInfo ? _fanmFileInfo.frames : null;
			if (!frameList)
				return;
			
			var listLen:int = frameList.length;
			for (var i:int = 0; i < RULER_LENGTH; ++i)
			{
				var textField:TextField = _frameTextList[i];
				if (textField)
				{
					var frameIdx:int = displayIndex2FramesIndex(i);
					
					var value:String = (frameList[frameIdx] != null) ? String(frameList[frameIdx]) : "";
					textField.text = value;
					textField.mouseEnabled = (value != "" && value != null);
				}
			}
		}
		
		public function framesIndex2DisplayIndex(frameIdx:int):int
		{
			var frameList:Array = _fanmFileInfo ? _fanmFileInfo.frames : null;
			if (!frameList)
				return -1;
			
			var currDir:int = timeLinePanel.famDisplay.dirLock;
			if (currDir < 0)		// 没有选择方向，直接返回帧索引
				return frameIdx;
			else
			{
				var famDir:uint = timeLinePanel.famDisplay.mcyyDir2famDir( currDir );			// mcyy方向转fam方向
				var frmBegin:int = timeLinePanel.famDisplay.getDirFrmBegin( famDir );
				var frmEnd:int = timeLinePanel.famDisplay.getDirFrmEnd( famDir );
				
				if (frameIdx < frmBegin || frameIdx >= frmEnd)
					return -1;
				else
					return frameIdx - frmBegin;
			}
		}
		
		public function displayIndex2FramesIndex(displayIdx:int):int
		{
			var frameList:Array = _fanmFileInfo ? _fanmFileInfo.frames : null;
			if (!frameList)
				return -1;
			
			var currDir:int = timeLinePanel.famDisplay.dirLock;
			if (currDir < 0)		// 没有选择方向，直接返回帧索引
				return displayIdx;
			else
			{
				var famDir:uint = timeLinePanel.famDisplay.mcyyDir2famDir( currDir );			// mcyy方向转fam方向
				var frmBegin:int = timeLinePanel.famDisplay.getDirFrmBegin( famDir );
				var frmEnd:int = timeLinePanel.famDisplay.getDirFrmEnd( famDir );
				
				var idx:int = frmBegin + displayIdx;
				if (idx >= frmEnd)
					return -1;
				else
					return idx;
			}
		}
		
		public function getSelectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function setFrameSelect(index:int, isFrameIdx:Boolean = true):void
		{
			if (isFrameIdx)
				index = this.framesIndex2DisplayIndex(index);
			
			if (_selectedIndex >= 0)
			{
				var textField:TextField = _frameTextList[_selectedIndex];
				if (textField)
					textField.textColor = 0x0000FF;
			}
			
			_selectedIndex = index;
			if (index < 0)
			{
				if (_selectShape && _selectShape.parent)
					_selectShape.parent.removeChild(_selectShape);	
				return;
			}
			
			var newTextField:TextField = _frameTextList[_selectedIndex];
			if (newTextField)
				newTextField.textColor = 0xFF0000;
			
			if (!_selectShape.parent)
				addChildAt(_selectShape, 0);
			_selectShape.x = index * SEGMENT_WIDTH;		
		}
		
		public function addFrame():Boolean
		{
			if (_selectedIndex < 0 || _selectedIndex>= RULER_LENGTH)
				return false;
			
			if (!_fanmFileInfo)
				return false;
			
			// 如果当前fam是5方向，为选择方向播放而是全部播放，不允许编辑帧
			if ((timeLinePanel.famDisplay.famDirCount == 5) &&
				timeLinePanel.famDisplay.dirLock < 0)
			{
				Alert.show("5方向动画不允许全帧编辑，只能按方向编辑", "error");
				return false;
			}
			
			if (timeLinePanel.famDisplay.famDirCount == 5)
			{
				// 5方向编辑帧
				var frameIdx:int = this.displayIndex2FramesIndex(_selectedIndex);
				addDirect5Frame(_selectedIndex);
			}
			else
			{
				var frames:Array = _fanmFileInfo.frames;
				var length:int = frames.length;
				if (_selectedIndex >= 0 && _selectedIndex < length)
				{
					var value:int = frames[_selectedIndex];
					frames.splice(_selectedIndex + 1, 0, value);
				}
			}
			
			this.updateFrameValue();
			timeLinePanel.famDisplay.modifyFlag = true;
			this.dispatchEvent(new Event(Event.SELECT));
			return true;
		}
		
		private function addDirect5Frame(index:int):void
		{
			var frames:Array = _fanmFileInfo.frames;
			var indexList:Array = [];
			for (var i:int = 4; i >= 0; --i)
			{
				var frameBegin:uint = timeLinePanel.famDisplay.getDirFrmBegin(i);
				var frameIdx:int = frameBegin + index;
				indexList.push(frameIdx);
			}
			
			for (i = 0; i < 5; ++i)
			{
				var idx:int = indexList[i];
				var value:int = frames[idx];
				
				frames.splice(idx + 1, 0, value);
			}
		}
		
		private function removeDirect5Frame(index:int):void
		{
			var frames:Array = _fanmFileInfo.frames;
			var indexList:Array = [];
			for (var i:int = 4; i >= 0; --i)
			{
				var frameBegin:uint = timeLinePanel.famDisplay.getDirFrmBegin(i);
				var frameIdx:int = frameBegin + index;
				indexList.push(frameIdx);
			}
			
			for (i = 0; i < 5; ++i)
			{
				var idx:int = indexList[i];
				frames.splice(idx, 1);
			}
		}
		
		public function removeFrame():Boolean
		{
			if (_selectedIndex < 0 || _selectedIndex>= RULER_LENGTH)
				return false;
			
			if (!_fanmFileInfo)
				return false;
			
			// 如果当前fam是5方向，为选择方向播放而是全部播放，不允许编辑帧
			if ((timeLinePanel.famDisplay.famDirCount == 5) &&
				timeLinePanel.famDisplay.dirLock < 0)
			{
				Alert.show("5方向动画不允许全帧编辑，只能按方向编辑", "error");
				return false;
			}
			
			if (timeLinePanel.famDisplay.famDirCount == 5)
			{
				// 5方向编辑帧
				var frameIdx:int = this.displayIndex2FramesIndex(_selectedIndex);
				removeDirect5Frame(_selectedIndex);
			}
			else
			{
				var frames:Array = _fanmFileInfo.frames;
				var length:int = frames.length;
				if (_selectedIndex >= 0 && _selectedIndex < length)
				{
					frames.splice(_selectedIndex, 1);
				}
			}
			
			this.updateFrameValue();
			timeLinePanel.famDisplay.modifyFlag = true;
			this.dispatchEvent(new Event(Event.SELECT));
			return true;
		}
		
		private function setup():void
		{
			initSelectShape();
			
			for (var i:int = 0; i < RULER_LENGTH; ++i)
				drawSegmentByIndex(i);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function initSelectShape():void
		{
			if (!_selectShape)
			{
				_selectShape = new Shape();
				_selectShape.graphics.clear();
				_selectShape.graphics.lineStyle(1, 0xFF0000, 1.0);
				_selectShape.graphics.drawRect(0, 0, SEGMENT_WIDTH, SEGMENT_HEIGHT * 2);
				_selectShape.graphics.endFill();
			}
		}
		
		private function drawSegmentByIndex(index:int):void
		{
			// 需要添加索引显示
			if (index == 0 || (((index + 1) % 5) == 0))
			{
				var textField:TextField = new TextField();
				textField.mouseEnabled = false;
				textField.text = (index + 1).toString();
				textField.width = textField.textWidth + 4;
				textField.height = textField.textHeight + 4;
				textField.x = (index + 0.5) * SEGMENT_WIDTH - textField.width * 0.5;
				textField.y = SEGMENT_HEIGHT * 0.3;
				addChild(textField);
			}
			
			// 画刻度间隔
			graphics.beginFill(0);
			graphics.lineStyle(1);
			graphics.moveTo((index + 1) * SEGMENT_WIDTH, SEGMENT_HEIGHT * 0.8);
			graphics.lineTo((index + 1) * SEGMENT_WIDTH, SEGMENT_HEIGHT);
			graphics.endFill();
			
			// 
			var backColor:uint = (index % 2) == 0 ? 0xA8A8A8 : 0xFFFFFF;
			graphics.beginFill(backColor);
			graphics.drawRect(index * SEGMENT_WIDTH, SEGMENT_HEIGHT, SEGMENT_WIDTH, SEGMENT_HEIGHT);
			graphics.endFill();
			
			var frameText:TextField = new TextField();
			frameText.type = TextFieldType.INPUT;
			frameText.multiline = false;
			frameText.wordWrap = false;
			frameText.defaultTextFormat = new TextFormat("lisu",10,0x0000FF,null,null,null,null,null,TextFormatAlign.CENTER);
			frameText.width = SEGMENT_WIDTH;
			frameText.height = frameText.defaultTextFormat.size + 4;
			frameText.x = index * SEGMENT_WIDTH;
			frameText.y = SEGMENT_HEIGHT + frameText.height * 0.5;
			frameText.addEventListener(Event.CHANGE, onFrameTextValueChanged);
			addChild(frameText);
			_frameTextList[index] = frameText;
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			var mouseX:int = this.mouseX;
			var frameIndex:int = mouseX / SEGMENT_WIDTH;
			if (frameIndex < 0)
				return;
			
			this.setFrameSelect(frameIndex, false);
			this.dispatchEvent(new Event(Event.SELECT));
		}
		
		private function onFrameTextValueChanged(e:Event):void
		{
			var textField:TextField = e.currentTarget as TextField;
			var index:int = _frameTextList.indexOf(textField);
			if (index < 0)
				return;
			
			if (_fanmFileInfo && _fanmFileInfo.frames)
			{
				var frameIdx:int = this.displayIndex2FramesIndex(index);
				var length:int = _fanmFileInfo.frames.length;
				if (frameIdx < 0 || frameIdx >= length)
					return;
				
				if (!textField.text)
					return;
				
				var value:int = int(parseInt(textField.text, 10));
				if (value < 0)
					value = 0;
				if (value >= _fanmFileInfo.count)
					value = _fanmFileInfo.count - 1;
				textField.text = String(value);
				
				_fanmFileInfo.frames[frameIdx] = value;
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}