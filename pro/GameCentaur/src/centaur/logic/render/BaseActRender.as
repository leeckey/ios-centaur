package centaur.logic.render
{
	import centaur.logic.act.BaseActObj;
	
	import flash.display.Sprite;

	public class BaseActRender extends Sprite
	{
		public var actObj:BaseActObj;
		
		public function BaseActRender(actObj:BaseActObj)
		{
			this.actObj = actObj;
			
			init();
		}
		
		protected function init():void
		{
		}
	}
}