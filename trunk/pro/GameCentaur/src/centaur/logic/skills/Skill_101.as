package centaur.logic.skills
{
	import centaur.data.card.CardData;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 阻击:给HP最少的卡牌100点伤害 
	 * @author minnie
	 * 
	 */	
	public class Skill_101 extends BaseSkill
	{
		// 造成的伤害值
		public var damage:int;
		
		public function Skill_101(data:SkillData, card:BaseCardObj)
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
			
			damage = data.param1;
		}
		
		/**
		 * 施放技能 
		 * 
		 */		
		public override function doSkill():void
		{
			if (!card || card.isDead)
				return;
			
			var target:Array = getTarget();
			if (target == null || target.length == 0)
				return;
			
			var targetCard:BaseCardObj = target[0] as BaseCardObj;
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [targetCard.objID]));
			targetCard.onHurt(damage);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
	}
}