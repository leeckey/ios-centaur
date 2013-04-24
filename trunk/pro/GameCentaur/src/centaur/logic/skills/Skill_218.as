package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 转生：死亡时有50%概率进入等待区 
	 * @author liq
	 * 
	 */	
	public class Skill_218 extends BaseSkill
	{
		/**
		 * 造成的伤害值 
		 */		
		public var rate:Number;
		
		public function Skill_218(data:SkillData, card:BaseCardObj)
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
			
			rate = data.param1 / 100;
		}
		
		/**
		 * 监听死亡事件
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_AFTER_DEAD, onAfterDead, false, _priority);
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
				card.removeEventListener(CardEvent.ON_AFTER_DEAD, onAfterDead);
			}
			
			super.removeCard();
		}
		
		/**
		 * 50%概率进入等待区 
		 * @param event
		 * 
		 */		
		public function onAfterDead(event:CardEvent):void
		{
			if (Math.random() < rate)
			{
				// 复活成功
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
				
				card.owner.cardRevive(card);
			}
		}
	}
}