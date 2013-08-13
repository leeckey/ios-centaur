package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	
	/**
	 * 诅咒技能,扣除对方英雄生命值 
	 * @author liq
	 * 
	 */	
	public class Skill_106 extends BaseSkill
	{
		/**
		 * 伤害值 
		 */		
		public var damage:int;
		
		public function Skill_106(data:SkillData, card:BaseCardObj)
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
			damage = data.param1 * data.skillLevel;
		}
		
		/**
		 * 释放主动技能 
		 * 
		 */	
		public override function doSkill():void
		{
			if (!card || card.isDead)
				return;
			
			var target:Array = getTarget();
			if (target == null || target.length == 0)
				return;
			
			var enemy:BaseActObj = target[0] as BaseActObj;
			
			if (enemy == null)
				return;
			
			// 扣除HP
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, makeIDArray(target)));
			enemy.deductHp(damage);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
	}
}