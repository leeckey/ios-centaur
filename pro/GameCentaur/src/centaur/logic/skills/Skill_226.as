package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 死契技能
	 * @author liq
	 * 
	 */	
	public class Skill_226 extends BaseSkill
	{
		// 释放的技能ID
		public var param1:int;
		
		// 释放的技能等级
		public var param2:int;
		
		// 降临时释放的技能
		private var skill:BaseSkill;
		
		public function Skill_226(data:SkillData, card:BaseCardObj, skillPara:Array)
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
			skill = getSkillByID(card, param1, [param2]);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_PRE_DEAD, onPreDead, false, _priority);
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
				card.removeEventListener(CardEvent.ON_PRE_DEAD, onPreDead);
			}
			
			super.removeCard();
		}
		
		/**
		 * 释放出场技能
		 * @param event
		 * 
		 */		
		public function onPreDead(event:CardEvent):void
		{
			skill.doSkill();
		}
		
		/**
		 * 死契技能的特殊名称显示方法 
		 * @return 
		 * 
		 */		
		public override function get skillName():String
		{
			var temp:String = "[" +　super.skillName + "]";
			temp += skill.skillName;
			if (param2 > 0)
				temp += param2.toString();
			
			return temp;
		}
		
		/**
		 * 显示技能描述 
		 * @return 
		 * 
		 */		
		public override function getSkillDesc():String
		{
			var desc:String = super.getSkillDesc();
			
			return desc.replace("{0}", skill.skillName).replace("{1}", skill.getSkillDesc());
		}
	}
}