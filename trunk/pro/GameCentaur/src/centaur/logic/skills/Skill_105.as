package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	
	/**
	 * 祈祷:恢复我方英雄50点生命值 
	 * @author liq
	 * 
	 */	
	public class Skill_105 extends BaseSkill
	{
		/**
		 * 治疗的血量 
		 */		
		public var cure:int;
		
		public function Skill_105(data:SkillData, card:BaseCardObj, skillPara:Array)
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
			
			cure = data.param1 * skillLevel;
		}
		
		/**
		 * 释放主动技能 
		 * 
		 */	
		public override function doSkill():void
		{
			if (!card || card.isDead)
				return;
			
			
			var owner:BaseActObj = card.owner;
			
			if (owner == null || !owner.isHurt())
				return;
			
			// 扣除HP
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [owner]));
			owner.addHp(cure);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
	}
}