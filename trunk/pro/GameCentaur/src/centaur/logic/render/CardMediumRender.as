package centaur.logic.render
{
	import assetcard.cardMediumRenderSkin;
	
	import assetscard.images.CardRace1;
	
	import centaur.data.GlobalAPI;
	import centaur.data.buff.BuffData;
	import centaur.data.buff.BuffDataList;
	import centaur.data.card.CardTemplateData;
	import centaur.display.control.GBitmapNumberText;
	import centaur.effects.ShakeEffect;
	import centaur.interfaces.IMovieClip;
	import centaur.logic.act.BaseCardObj;
	import centaur.manager.EmbedAssetManager;
	import centaur.movies.MovieClipFactory;
	import centaur.utils.NumberType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
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
		
		private var _buffDic:Dictionary;
		
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
			
			_buffDic = new Dictionary();
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
			
			if (_width == 0)
			{
				_width = 120;
				_height = 175;
			}
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
			_attack += attack;
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
		
		/**
		 *   添加BUFF效果
		 */ 
		override public function addBuff(buffID:uint):void
		{
			if (!buffID)
				return;
			
			var buffData:BuffData = BuffDataList.getBuffData(buffID);
			if (!buffData)
				return;
			
			var buffEffect:IMovieClip = _buffDic[buffID] as IMovieClip;
			if (buffEffect)
				return;
			
			buffEffect = _buffDic[buffID] = MovieClipFactory.getAvailableMovie();
			buffEffect.setLoop(-1);
			buffEffect.setPath(buffData.effectPath);
			buffEffect.play();
			
			(buffEffect as DisplayObject).x = this.width * 0.5;
			(buffEffect as DisplayObject).y = this.height * 0.5;
			addChild(buffEffect as DisplayObject);
		}
		
		/**
		 *   移除BUFF效果
		 */ 
		override public function removeBuff(buffID:uint):void
		{
			if (!buffID)
				return;
			
			var buffEffect:IMovieClip = _buffDic[buffID] as IMovieClip;
			if (!buffEffect)
				return;
			
			MovieClipFactory.recycleMovie(buffEffect);
			delete _buffDic[buffID];
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