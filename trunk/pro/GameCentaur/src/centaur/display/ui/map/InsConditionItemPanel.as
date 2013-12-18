package centaur.display.ui.map
{
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;

	public final class InsConditionItemPanel extends GBuilderBase
	{
		public var extraShape:GBase;
		public var finishShape:GBase;
		
		private var _finish:Boolean;
		
		public function InsConditionItemPanel(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
		}
		
		public function setFinish(finish:Boolean):void
		{
			_finish = finish;
			if (extraShape)
				extraShape.visible = !_finish;
			if (finishShape)
				finishShape.visible = _finish;
		}
	}
}