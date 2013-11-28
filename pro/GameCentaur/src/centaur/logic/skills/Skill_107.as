package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 瘟疫技能:使对方所有卡牌丧失10点攻击力和生命值
	 * @author liq
	 * 
	 */	
	public class Skill_107 extends BaseSkill
	{
		/**
		 * 减少的攻击力 
		 */		
		public var attack:Number;
		
		public function Skill_107(data:SkillData, card:BaseCardObj, skillPara:Array)
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
			
			attack = data.param1 * skillLevel;
		}
		

		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			if (targetCard.onSkillHurt(this, 0) >= 0)
			{
				targetCard.deductHP(attack);
				targetCard.deductAttack(attack);
			}
		}
	}
}