package centaur.logic.render
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import org.osmf.net.SwitchingRuleBase;

	/**
	 *   卡片的显示对象
	 */ 
	public class BaseCardRender extends Sprite
	{
		public var cardObj:BaseCardObj;
		
		private var _subRender:SubCardRender;
		private var _skinType:int = -1;
		
		public function BaseCardRender(data:BaseCardObj)
		{
			this.cardObj = data;
		}
		
		public function updateRenderByType(skinType:int = BaseCardObj.SKIN_HEAD_TYPE):void
		{
			if (_skinType == skinType)
				return;
			
			if (_subRender)
				_subRender.destory();
			
			switch (skinType)
			{
				case BaseCardObj.SKIN_HEAD_TYPE:
				{
					_subRender = new CardHeadRender(cardObj);
				}break;
				case BaseCardObj.SKIN_NORMAL_TYPE:
				{
					_subRender = new CardMediumRender(cardObj);
				}break;
				case BaseCardObj.SKIN_HEAD_DEAD_TYPE:
				{
					_subRender = new CardHeadDeadRender(cardObj);
				}break;
			}
			
			if (_subRender)
				addChild(_subRender);
		}
		
		override public function get width():Number
		{
			if (_subRender)
				return _subRender.width;
			
			return this.width;
		}
		
		override public function get height():Number
		{
			if (_subRender)
				return _subRender.height;
			
			return this.height;
		}
		
		public function handleHPChange(damage:int):void
		{
			if (_subRender)
				_subRender.handleHPChange(damage);
		}
		
		public function handleAttackChange(attack:int):void
		{
			if (_subRender)
				_subRender.handleAttackChange(attack);
		}
		
		public function handleWaitRoundChange(round:int):void
		{
			if (_subRender)
				_subRender.handleWaitRoundChange(round);
		}
	}
}