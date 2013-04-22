package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.action.*;
	
	public class Skill_206 extends BaseSkill
	{
		/**
		 * 最大承受伤害 
		 */		
		public var maxDamage:int;
		
		public function Skill_206(data:SkillData, card:BaseCardObj)
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
			
			maxDamage = data.param1;
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
				card.addEventListener(CardEvent.ON_PRE_SKILL_HURT, onPreSkillHurt, false, _priority);
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
				card.removeEventListener(CardEvent.ON_PRE_SKILL_HURT, onPreSkillHurt);
			}
			
			super.removeCard();
		}
		
		/**
		 * 减少受到的技能攻击伤害 
		 * @param event
		 * 
		 */		
		public function onPreSkillHurt(event:CardEvent):void
		{
			if (card.lastBeAttackVal > 0)
			{				
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
				card.lastBeAttackVal = Math.min(card.lastBeAttackVal, maxDamage);
				trace("最高受到技能" + maxDamage + "伤害");
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			}
		}
	}
}