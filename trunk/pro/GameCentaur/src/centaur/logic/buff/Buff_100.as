package centaur.logic.buff
{
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 冰冻buff 
	 * @author liq
	 * 
	 */	
	public class Buff_100 extends BaseBuff
	{
		public function Buff_100(card:BaseCardObj)
		{
			id = 100;
			round = 1;
			super(card);
		}
		
		/**
		 * 设置卡牌停止行动一回合 
		 * 
		 */		
		public override function addBuff():void
		{
			card.isActive = false;
			card.addEventListener(CardEvent.ON_ROUND_END, onRoundEnd);
			BuffNotifyAction.getAction(id, card.objID);
		}
		
		/**
		 * 除去buff 
		 * 
		 */		
		public override function deBuff():void
		{
			card.removeEventListener(CardEvent.ON_ROUND_END, onRoundEnd);
			card.isActive = true;
			BuffNotifyAction.getAction(id, card.objID, BuffNotifyAction.BUFF_REMOVE_ACTION);
		}
		
		/**
		 * 卡牌回合结束事件 
		 * 
		 */		
		private function onRoundEnd(event:CardEvent):void
		{
			if (--round <= 0)
			{
				deBuff();
			}
		}
	}
}