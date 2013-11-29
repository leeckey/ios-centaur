package centaur.logic.buff
{
	import centaur.data.buff.BuffData;
	import centaur.logic.act.BaseCardObj;

	/**
	 * 所有buff类的基类 
	 * @author liq
	 * 
	 */	
	public class BaseBuff
	{
		/**
		 * buff的id 
		 */		
		public var id:int;
		
		/**
		 * buff的回合数
		 * 
		 */		
		public var round:int;
		
		/**
		 * 是否可叠加 
		 */		
		public var superposition:int;
		
		/**
		 * 技能等级 
		 */		
		public var level:int;
		
		/**
		 * buff作用的卡牌 
		 */		
		public var card:BaseCardObj;
		
		public function BaseBuff(card:BaseCardObj, data:BuffData)
		{
			this.card = card;
			this.id = data.id;
			this.round = data.round;
			this.superposition = data.superposition;
			this.level = data.level;
			if (card != null)
				card.addBuff(this);
		}
		
		/**
		 * buff 作用效果 
		 * @return 
		 * 
		 */		
		public function addBuff():void
		{
		}
		
		/**
		 * 除去buff 
		 * 
		 */		
		public function deBuff():void
		{
			if (card != null)
				card.deBuff(this);
		}
		
		/**
		 * 吸收另外一个buff的数据 
		 * 
		 */		
		public function copy(buff:BaseBuff):void
		{
			this.round = buff.round;
		}
	}
}