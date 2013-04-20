package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.buff.Buff_100;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 治疗卡牌 
	 * @author liq
	 * 
	 */	
	public class Skill_104 extends BaseSkill
	{
		/**
		 * 治疗的血量 
		 */		
		public var cure:int;
		
		public function Skill_104(data:SkillData, card:BaseCardObj)
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
			
			cure = data.param1;
		}
		
		/**
		 * 施放治疗术 
		 * 
		 */		
		public override function doSkill():void
		{
			if (!card || card.isDead)
				return;
			
			var target:Array = getTarget();
			if (target == null || target.length == 0)
				return;
			
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, makeIDArray(target)));
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			
			var targetCard:BaseCardObj;
			for (var i:int = 0; i < target.length; i++)
			{
				targetCard = target[i] as BaseCardObj;
				if (targetCard != null)
				{
					targetCard.addHP(cure);
				}
			}
		}
	}
}