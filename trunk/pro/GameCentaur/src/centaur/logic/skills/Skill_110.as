package centaur.logic.skills
{
	import centaur.data.combat.CombatData;
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 复活:将我方1张无复活技能的卡牌从墓地召唤上场
	 * @author liq
	 * 
	 */	
	public class Skill_110 extends BaseSkill
	{
		public function Skill_110(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
		}
		
		/**
		 * 将我方1张无复活技能的卡牌从墓地召唤上场
		 * @param targetCard
		 * 
		 */		
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			targetCard.doRevive();
		}
		
		/**
		 * 返回墓地中没有复活技能的卡牌 
		 * @return 
		 * 
		 */		
		public override function getTarget():Array
		{
			var targets:Array = [];
			var combatData:CombatData = card.owner.combatData;
			var deadCard:Array = combatData.selfCemeteryArea.concat();
			for (var i:int = 0; i < deadCard.length; i++)
			{
				// 剔除掉有相同技能的卡牌
				var card:BaseCardObj = deadCard[i] as BaseCardObj;
				if (card.skills.indexOf(this.skillID) == -1)
					targets.push(card);
			}
			
			var idx:int = Math.random() * targets.length;
			
			return [ targets[idx] ];
		}
	}
}