package com.kingnare.skins.frames
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import mcyy.loader.fanim.FamFileWrite;
	import mcyy.loader.fanim.FanimDisplay;

	/**
	 *   时间轴面板，包括刻度，播放时间等
	 *   @author wangq 2012.09.28
	 */ 
	public final class TimeLinePanel extends Sprite
	{
		// 刻度面板
		public var rulerPanel:ScaleRulerPanel;
		
		public var famDisplay:FanimDisplay;
		
		// 播放耗时显示
		private var _elapseText:TextField;
		
		public function TimeLinePanel(display:FanimDisplay)
		{
			famDisplay = display;
			
			setup();
		}
		
		public function updateScrollValue(value:Number):void
		{
			if (rulerPanel.width <= 800)
				rulerPanel.x = 0;
			else
			{
				rulerPanel.x = (800 - rulerPanel.width) * value;
			}
		}
		
		public function updatePlayTime(elapseTime:int):void
		{
			var timeStr:String = Number(elapseTime * 0.001).toFixed(2);
			if (_elapseText)
				_elapseText.text = timeStr + "s";
		}
		
		protected function setup():void
		{
			rulerPanel = new ScaleRulerPanel();
			addChild(rulerPanel);
			rulerPanel.timeLinePanel = this;
			
			initElapseText();
			
			this.scrollRect = new Rectangle(0, 0, 800, 100);
		}
		
		private function initElapseText():void
		{
			_elapseText = new TextField();
			_elapseText.mouseEnabled = false;
			_elapseText.width = 30;
			_elapseText.height = 20;
			_elapseText.x = 200;
			_elapseText.y = ScaleRulerPanel.SEGMENT_HEIGHT * 2 + 2;
			_elapseText.text = "0.00s";
			addChild(_elapseText);
		}
	}
}