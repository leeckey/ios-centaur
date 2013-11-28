package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.action.*;
	
	public class Skill_205 extends BaseSkill
	{
		/**
		 * 最大承受伤害 
		 */		
		public var maxDamage:int;
		
		public function Skill_205(data:SkillData, card:BaseCardObj, skillPara:Array)
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
			
			maxDamage = data.param1 - data.param2 * skillLevel;
		}
		
		/**
		 * 监听被普通攻击事件
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
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
				card.lastBeAttackVal = Math.min(card.lastBeAttackVal, maxDamage);
				trace("最高受到" + maxDamage + "伤害");
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			}
		}
	}
}