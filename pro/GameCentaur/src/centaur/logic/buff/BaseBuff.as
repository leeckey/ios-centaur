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
		 * buff作用的卡牌 
		 */		
		public var card:BaseCardObj;
		
		public function BaseBuff(card:BaseCardObj, data:BuffData)
		{
			this.card = card;
			this.id = data.id;
			this.round = data.round;
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