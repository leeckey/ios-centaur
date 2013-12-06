package centaur.manager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public final class LayerManager
	{
		private var _container:DisplayObjectContainer;
		
		private var _moduleLayer:DisplayObjectContainer;
		private var _popLayer:DisplayObjectContainer;
		private var _tipLayer:DisplayObjectContainer;
		private var _topLayer:DisplayObjectContainer;
		private var _mouseLayer:DisplayObjectContainer;
		
		public function LayerManager(sp:DisplayObjectContainer)
		{
			_container = sp;
			initLayer();
		}
		
		private function initLayer():void
		{
			_moduleLayer = new Sprite();
			_popLayer = new Sprite();
			_popLayer.mouseEnabled = false;
			_tipLayer = new Sprite();
			_tipLayer.mouseEnabled = false;
			_tipLayer.mouseChildren = false;
			_topLayer = new Sprite();
			_topLayer.mouseEnabled = false;
			_mouseLayer = new Sprite();
			_mouseLayer.mouseEnabled = false;
			
			_container.addChild(_moduleLayer);
			_container.addChild(_popLayer);
			_container.addChild(_tipLayer);
			_container.addChild(_topLayer);
			_container.addChild(_mouseLayer);
		}
		
		private var _moduleContent:Sprite;
		private var _lastModuleContent:Sprite;
		private var _moduleList:Array = [];
		public function setModuleContent(content:Sprite, record:Boolean = true):void
		{
			if (_moduleContent != content)
			{
				if (_moduleContent && _moduleContent.parent)
					_moduleContent.parent.removeChild(_moduleContent);
				
				if (record)
				{
					// 记录上次的面板
					_lastModuleContent = _moduleContent;
					if (_lastModuleContent && _moduleList.indexOf(_lastModuleContent) == -1)
						_moduleList.push(_lastModuleContent);
				}
				
				_moduleContent = content;
				
				if (_moduleContent && _moduleContent.parent != _moduleLayer)
					_moduleLayer.addChild(_moduleContent);
				
			}
		}
		
		public function returnLastModule():void
		{
			if (_moduleList.length == 0)
				return;
			
			var lastModule:Sprite = _moduleList.pop();
			if (lastModule)
				setModuleContent(lastModule, false);
		}
		
		public function getModuleContent():Sprite
		{
			return _moduleContent;
		}
		
		public function getLastModuleContent():Sprite
		{
			return _lastModuleContent;
		}
		
		/**
		 * 放置模块和模块过渡层
		 * @return 
		 * 
		 */		
		public function getModuleLayer():DisplayObjectContainer
		{
			return _moduleLayer;
		}
		
		public function getPopLayer():DisplayObjectContainer
		{
			return _popLayer;
		}
		
		public function getTipLayer():DisplayObjectContainer
		{
			return _tipLayer;
		}
		
		
		public function getMouseLayer():DisplayObjectContainer
		{
			return _mouseLayer;
		}
		
		public function getTopLayer():DisplayObjectContainer
		{
			return _topLayer;
		}
	}
}