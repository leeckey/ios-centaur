package centaur.logic.buff
{
	import centaur.data.buff.BuffData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 闪电buff 
	 * @author liq
	 * 
	 */	
	public class Buff_101 extends BaseBuff
	{
		
		public function Buff_101(card:BaseCardObj, data:BuffData)
		{
			super(card, data);
		}
		
		/**
		 * 禁止卡牌普通攻击一回合 
		 * 
		 */		
		public override function addBuff():void
		{
			card.addEventListener(CardEvent.ON_ROUND_END, onRoundEnd);
			card.canAttack = false;
			CombatLogic.combatList.push(BuffNotifyAction.getAction(id, card.objID));
		}
		
		/**
		 * 除去buff 
		 * 
		 */		
		public override function deBuff():void
		{
			card.removeEventListener(CardEvent.ON_ROUND_END, onRoundEnd);
			card.canAttack = true;
			CombatLogic.combatList.push(BuffNotifyAction.getAction(id, card.objID, BuffNotifyAction.BUFF_REMOVE_ACTION));
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