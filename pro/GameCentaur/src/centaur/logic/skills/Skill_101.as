package centaur.logic.skills
{
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	
	/**
	 * 阻击:给HP最少的卡牌100点伤害 
	 * @author minnie
	 * 
	 */	
	public class Skill_101 extends BaseSkill
	{
		// 造成的伤害值
		public var damage:int;
		
		public function Skill_101(card:BaseCardObj)
		{	
			// TODO:改为读取配置
			_skillID = 101;
			damage = 100;
			selectTargetType = SkillEnumDefines.TARGET_MIN_HP_TYPE;
			
			registerCard(card);
		}
		
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