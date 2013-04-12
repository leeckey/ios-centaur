package centaur.logic.render
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class BaseCardRender extends Sprite
	{
		public var cardObj:BaseCardObj;
		
		private var _text:TextField;	// 暂时调试测试显示用
		
		public function BaseCardRender(data:BaseCardObj)
		{
			this.cardObj = data;
			
			////----wangq 
			_text = new TextField();
			addChild(_text);
		}
		
		public function updateRenderByType(skinType:int = BaseCardObj.SKIN_HEAD_TYPE):void
		{
			_text.text = "卡牌ID" + cardObj.objID + "--" + skinType;
		}
	}
}