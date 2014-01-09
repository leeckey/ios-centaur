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
	 * 将墓地中的卡牌送回牌堆
	 * @author liq
	 * 
	 */	
	public class Skill_111 extends BaseSkill
	{
		// 回魂的卡牌数量
		public var num:int = 0;
		
		public function Skill_111(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
		}
		
		/**
		 * 设置参数 
		 * @param data
		 * 
		 */		
		public override function initConfig(data:SkillData):void	
		{
			num = data.param1;
		}
		
		/**
		 * 将墓地中卡牌送回牌堆
		 * @param targetCard
		 * 
		 */		
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			targetCard.doBack();
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
				var target:BaseCardObj = deadCard[i];
				if (target)
				{
					if (targets.length >= num)
					{
						var replaceIdx:int = Math.random() * (num + 1);
						if (replaceIdx < num)
							target[replaceIdx] = target;
					}
					else
						targets.push(target);
				}
			}
			
			return targets;
		}
	}
}