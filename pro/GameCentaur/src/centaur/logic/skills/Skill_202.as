package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.action.*;
	
	/**
	 * 受到普通攻击时,减少30点伤害 
	 * @author minnie
	 * 
	 */	
	public class Skill_202 extends BaseSkill
	{
		/**
		 * 减免的伤害值 
		 */		
		public var defence:int;
		
		public function Skill_202(data:SkillData, card:BaseCardObj)
		{
			super(data, card);
		}
		
		/**
		 * 设置卡牌参数 
		 * @param data
		 * 
		 */		
		public override function initConfig(data:SkillData):void
		{
			// 设置公共信息
			super.initConfig(data);
			
			defence = data.param1;
		}
		
		/**
		 * 监听攻击开始和结束的事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_PRE_HURT, onPreHurt, false, _priority);
			}
		}
		
		/**
		 * 取消事件监听 
		 * 
		 */		
		public override function removeCard():void
		{
			if (card != null)
			{
				card.removeEventListener(CardEvent.ON_PRE_HURT, onPreHurt);
			}
			
			super.removeCard();
		}
		
		/**
		 * 减少受到的普通攻击伤害 
		 * @param event
		 * 
		 */		
		public function onPreHurt(event:CardEvent):void
		{
			if (card.lastBeAttackVal > 0)
			{
				card.lastBeAttackVal -= defence;
				
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
				trace("伤害减少了:" + defence + ",剩余伤害:" + card.lastBeAttackVal);
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			}
		}
	}
}