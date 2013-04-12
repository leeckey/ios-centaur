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