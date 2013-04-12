package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	
	/**
	 * 火球,对随机对方一人造成100-300点伤害 
	 * @author liq
	 * 
	 */	
	public class Skill_102 extends BaseSkill
	{
		/**
		 * 最小攻击力 
		 */		
		public var min:int
		
		/**
		 * 最大攻击力 
		 */		
		public var max:int;
		
		public function Skill_102(data:SkillData, card:BaseCardObj)
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
			
			min = data.param1;
			max = data.param2;
		}
		
		
		public override function doSkill():void
		{
			if (!card || card.isDead)
				return;
			
			var target:Array = getTarget();
			if (target == null || target.length == 0)
				return;
			
			// 计算伤害
			var hurt:int = min + (max - min) * Math.random();
			var targetCard:BaseCardObj = target[0] as BaseCardObj;
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [targetCard.objID]));
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			targetCard.onSkillHurt(card, hurt);
			
		}
	}
}