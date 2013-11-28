package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 反击：受到物理攻击时，立刻反击造成100点伤害 
	 * @author liq
	 * 
	 */	
	public class Skill_210 extends BaseSkill
	{
		/**
		 * 反击伤害值 
		 */		
		public var damage:int;
		
		public function Skill_210(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
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
			
			damage = data.param1 * skillLevel;
		}
		
		/**
		 * 监听受到技能伤害事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_AFTER_HURT, onAfterHurt, false, _priority);
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
				card.removeEventListener(CardEvent.ON_AFTER_HURT, onAfterHurt);
			}
			
			super.removeCard();
		}
		
		/**
		 * 立刻反击造成100点伤害
		 * @param event
		 * 
		 */		
		public function onAfterHurt(event:CardEvent):void
		{
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.attacker.objID]));
			card.attacker.onHurt(damage);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
	}
}