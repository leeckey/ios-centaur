package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 降临技能
	 * @author liq
	 * 
	 */	
	public class Skill_225 extends BaseSkill
	{
		// 释放的技能ID
		public var param1:int;
		
		// 释放的技能等级
		public var param2:int;
		
		public function Skill_225(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
		}
		
		public override function SetCardData(data:Array):void
		{
			super.SetCardData(data);
			param1 = data[1];
			param2 = data[2];
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
				card.addEventListener(CardEvent.ON_PRESENT, onPresent, false, _priority);
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
				card.removeEventListener(CardEvent.ON_PRESENT, onPresent);
			}
			
			super.removeCard();
		}
		
		/**
		 * 释放出场技能
		 * @param event
		 * 
		 */		
		public function onPresent(event:CardEvent):void
		{
			var skill:BaseSkill = getSkillByID(card, param1, [param2]);
			skill.doSkill();
		}
	}
}