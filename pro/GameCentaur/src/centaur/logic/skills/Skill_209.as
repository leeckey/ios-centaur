package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 穿刺:对敌方卡牌造成伤害时，敌方英雄同时受到100%的伤害
	 * @author liq
	 * 
	 */	
	public class Skill_209 extends BaseSkill
	{
		/**
		 * 英雄伤血的比率
		 */		
		public var rate:Number;
		
		public function Skill_209(data:SkillData, card:BaseCardObj)
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
			
			rate = data.param1 * data.skillLevel / 100;
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
				card.addEventListener(CardEvent.ON_ATTACK_SUCC, onAttackSucc, false, _priority);
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
				card.removeEventListener(CardEvent.ON_ATTACK_SUCC, onAttackSucc);
			}
			
			super.removeCard();
		}
		
		/**
		 * 敌方英雄同时受到100%的伤害
		 * @param event
		 * 
		 */		
		public function onAttackSucc(event:CardEvent):void
		{		
			var target:BaseActObj = card.owner.enemyActObj;
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [target.objID]));
			target.deductHp(card.lastDamageValue);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
	}
}