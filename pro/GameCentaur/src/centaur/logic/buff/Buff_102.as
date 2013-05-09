package centaur.logic.buff
{
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 毒雾：行动结束后受到50点伤害 
	 * @author liq
	 * 
	 */	
	public class Buff_102 extends BaseBuff
	{
		/**
		 * 造成的伤害值 
		 */		
		public var damage:int;
		
		public function Buff_102(card:BaseCardObj)
		{
			id = 102;
			round = 1;
			damage = 80;
			super(card);
		}
		
		/**
		 * 设置回合结束时受到50点伤害 
		 * 
		 */		
		public override function addBuff():void
		{
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
			card.canAttack = true;
			BuffNotifyAction.getAction(id, card.objID, BuffNotifyAction.BUFF_REMOVE_ACTION);
		}
		
		/**
		 * 卡牌回合结束事件 
		 * 
		 */		
		private function onRoundEnd(event:CardEvent):void
		{
			if (card.isDead)
				return;
			
			card.onHurt(damage);
			if (--round <= 0)
			{
				deBuff();
			}
		}
	}
}