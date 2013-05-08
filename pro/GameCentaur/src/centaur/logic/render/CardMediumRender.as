package centaur.logic.render
{
	import assetcard.cardMediumRenderSkin;
	
	import assetscard.images.CardRace1;
	
	import centaur.data.GlobalAPI;
	import centaur.data.card.CardTemplateData;
	import centaur.display.control.GBitmapNumberText;
	import centaur.effects.ShakeEffect;
	import centaur.logic.act.BaseCardObj;
	import centaur.manager.EmbedAssetManager;
	import centaur.utils.NumberType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.Timer;
	
	import ghostcat.ui.controls.GText;

	/**
	 *   卡牌的中等大小显示类
	 *   @author wangq 2013.04.13
	 */ 
	public final class CardMediumRender extends SubCardRender
	{
		public var nameText:GText;					// 卡牌名称信息
		public var attackText:GBitmapNumberText;	// 攻击力信息
		public var hpText:GBitmapNumberText;		// 血量信息
		public var lvText:GText;					// 等级信息
		
		private var _raceBitmap:Bitmap;				// 种族背景图片
		private var _damageHightTimer:Timer;		// 受创时高亮效果的定时器	
		
		private var _attack:int;
		private var _hp:int;
		private var _name:String = "";
		
		private var _width:Number = 0.0;
		private var _height:Number = 0.0;
		
		public function CardMediumRender(cardObj:BaseCardObj)
		{
			super(cardObj, cardMediumRenderSkin);
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function get width():Number
		{
			return _width;	
		}
		
		override protected function getBitmapPath():String
		{
			return GlobalAPI.pathManager.getCardBodyByID(_cardObj.cardData.templateID);
		}
		
		override protected function setup():void
		{
			// 优先添加卡牌种族背景,先随机测试，到时读取配置表
			_raceBitmap = new Bitmap(GlobalAPI.loaderManager.getBitmapByClass(EmbedAssetManager.getCardRace(Math.random() * 4)));
			addChildAt(_raceBitmap, 0);
			
			super.setup();
			
			if (nameText)
				nameText.mouseChildren = nameText.mouseEnabled = false;
			if (attackText)
				attackText.mouseChildren = attackText.mouseEnabled = false;
			if (hpText)
				hpText.mouseChildren = hpText.mouseEnabled = false;
			if (lvText)
				lvText.mouseChildren = lvText.mouseEnabled = false;
			
			// 初始化战斗力，血量等信息
			if (_cardObj)
			{
				var templateData:CardTemplateData = _cardObj.cardData.getTemplateData();
				if (templateData)
					_name = templateData.name;
				_attack = _cardObj.cardData.attack;
				_hp = _cardObj.cardData.maxHP;
				
				
				if (attackText)
					attackText.setNumber(_attack, NumberType.SMALL_WHITE_NUMBER);
				if (hpText)
					hpText.setNumber(_hp, NumberType.SMALL_WHITE_NUMBER);
				if (lvText)
					lvText.text = "Lv:" + String(_cardObj.cardData.lv);
				if (nameText)
					nameText.text = _name;
			}
			
			_width = _raceBitmap.width;
			_height = _raceBitmap.height;
		}
		
		override protected function onBitmapLoadComplete(bitmapData:BitmapData):void
		{
			if (!bitmapData)
				return;
			
			_bitmap.x = (this.width - bitmapData.width) * 0.5;
			_bitmap.y = (this.height - bitmapData.height) * 0.5;
			
			super.onBitmapLoadComplete(bitmapData);
		}
		
		override public function handleAttackChange(attack:int):void
		{
			_attack += _attack;
			if (_attack < 1)
				_attack = 1;
			
			if (attackText)
				attackText.setNumber(_attack, NumberType.SMALL_WHITE_NUMBER, true);
		}
		
		override public function handleHPChange(damage:int):void
		{
			_hp -= damage;
			if (_hp < 0)
				_hp = 0;
			
			if (hpText)
				hpText.setNumber(_hp, NumberType.SMALL_WHITE_NUMBER, true);
			
			// 处理受创效果
			if (damage > 0)
				renderDamageEffect();
		}
		
		/**
		 *   处理受创效果
		 */ 
		private function renderDamageEffect():void
		{
			// 自身短暂高亮显示
			GlobalAPI.timerManager.stopDelayCall(_damageHightTimer, setDamageFilters);
			setDamageFilters(damageLightFilters);
			_damageHightTimer = GlobalAPI.timerManager.startDelayCall(200, setDamageFilters, 1, [emptyFilters]);
			
			// 自身轻微震动
			new ShakeEffect(this, "x", "y", null, 300, 3).startEffect();
		}
		
		private function setDamageFilters(filter:Array):void
		{
			this.filters = filter;
		}
		
		override public function destory():void
		{
			if (_raceBitmap && _raceBitmap.parent)
				_raceBitmap.parent.removeChild(_raceBitmap);
			_raceBitmap = null;
				
			super.destory();
		}
	}
}