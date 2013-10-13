package centaur.display.ui.role
{
	import centaur.logic.render.CardHeadRender;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;

	public final class ConfigHeadCardItem extends GBuilderBase
	{
		public var bg1:GBase;
		public var bg2:GBase;
		
		private var _headRender:CardHeadRender;
		
		public function ConfigHeadCardItem(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
			setup();
		}
		
		private function setup():void
		{
			setCardEnable(false);
		}
		
		public function setCardEnable(enable:Boolean):void
		{
			bg1.visible = enable;
			bg2.visible = !enable;
		}
		
		public function setHeadRender(render:CardHeadRender):void
		{
			if (_headRender != render)
			{
				if (_headRender && _headRender.parent)
					_headRender.parent.removeChild(_headRender);
				
				_headRender = render;
				
				if (_headRender)
				{
					if ( _headRender.parent != this)
						this.addChild(_headRender);
				}
			}
		}
	}
}