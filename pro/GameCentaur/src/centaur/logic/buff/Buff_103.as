package centaur.logic.buff
{
	import centaur.data.buff.BuffData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 裂伤Buff 
	 * @author liq
	 * 
	 */	
	public class Buff_103 extends BaseBuff
	{
		public function Buff_103(card:BaseCardObj, data:BuffData)
		{
			super(card, data);
		}
		
		/**
		 * 禁止卡牌治疗效果
		 * 
		 */		
		public override function addBuff():void
		{
			card.addEventListener(CardEvent.ON_ROUND_END, onRoundEnd);
			card.canCure = false;
			CombatLogic.combatList.push(BuffNotifyAction.getAction(id, card.objID));
		}
		
		/**
		 * 除去buff 
		 * 
		 */		
		public override function deBuff():void
		{
			card.removeEventListener(CardEvent.ON_ROUND_END, onRoundEnd);
			card.canCure = true;
			CombatLogic.combatList.push(BuffNotifyAction.getAction(id, card.objID, BuffNotifyAction.BUFF_REMOVE_ACTION));
			
			super.deBuff();
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