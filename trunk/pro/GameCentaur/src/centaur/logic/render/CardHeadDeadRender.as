package centaur.logic.render
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;

	/**
	 *   卡牌死亡后的头像显示
	 *   @author wangq 2013.04.26
	 */ 
	public final class CardHeadDeadRender extends CardHeadRender
	{
		public static const n:Number = 0.2;
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3086*(1-n)+ n,    0.6094*(1-n),    0.0820*(1-n),    0,    0,
			0.3086*(1-n),    0.6094*(1-n) + n,    0.0820*(1-n),    0,    0,
			0.3086*(1-n),    0.6094*(1-n)    ,    0.0820*(1-n) + n,    0,    0,
			0,    0,    0,    1,    0]);
		
		public function CardHeadDeadRender(cardObj:BaseCardObj)
		{
			super(cardObj, Sprite);
		}
		
		override protected function setup():void
		{
			super.setup();
			
			if (attackText && hpText)
				this.attackText.visible = this.hpText.visible = false;
			_bitmap.filters = [GRAY_FILTER];	
		}
	}
}