package centaur.logic.render
{
	import card.cardMediumRenderSkin;
	
	import centaur.data.GlobalAPI;
	import centaur.logic.act.BaseCardObj;
	
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GText;

	/**
	 *   卡牌的中等大小显示类
	 *   @author wangq 2013.04.13
	 */ 
	public final class CardMediumRender extends SubCardRender
	{
		public var attackText:GText;	// 攻击力信息
		public var hpText:GText;		// 血量信息
		
		private var _attack:int;
		private var _hp:int;
		
		public function CardMediumRender(cardObj:BaseCardObj)
		{
			super(cardObj, cardMediumRenderSkin);
		}
		
		override protected function getBitmapPath():String
		{
			return GlobalAPI.pathManager.getCardBodyByID(_cardObj.cardData.templateID);
		}
		
		override protected function setup():void
		{
			super.setup();
			
			if (attackText)
				attackText.mouseChildren = attackText.mouseEnabled = false;
			if (hpText)
				hpText.mouseChildren = hpText.mouseEnabled = false;
			
			// 初始化战斗力，血量等信息
			if (_cardObj)
			{
				_attack = _cardObj.cardData.attack;
				_hp = _cardObj.cardData.maxHP;
				if (attackText)
					attackText.text = String(_attack);
				if (hpText)
					hpText.text = String(_hp);
			}
		}
		
		override public function handleAttackChange(attack:int):void
		{
			_attack += _attack;
			if (_attack < 1)
				_attack = 1;
			
			if (attackText)
				attackText.text = String(_attack);
		}
		
		override public function handleHPChange(damage:int):void
		{
			_hp -= damage;
			if (_hp < 0)
				_hp = 0;
			
			if (hpText)
				hpText.text = String(_hp);
		}
	}
}