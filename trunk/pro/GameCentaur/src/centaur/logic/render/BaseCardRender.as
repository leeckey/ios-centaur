package centaur.logic.render
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.Sprite;

	public class BaseCardRender extends Sprite
	{
		public var cardObj:BaseCardObj;
		
		public function BaseCardRender(data:BaseCardObj)
		{
			this.cardObj = data;
		}
	}
}