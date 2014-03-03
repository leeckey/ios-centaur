package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	
	/**
	 * 血炼：使对方一张卡牌受到100点伤害，并且自身恢复相同的生命值
	 * @author liq
	 * 
	 */	
	public class Skill_102 extends BaseSkill
	{
		public var damage:int;
		
		public function Skill_102(data:SkillData, card:BaseCardObj, skillPara:Array)
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
			
			damage = data.param1 * skillLevel;
		}
		
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			var hurt:int = targetCard.onSkillHurt(this, damage);
			card.addHP(hurt);
		}
		
		/**
		 * 显示技能描述 
		 * @return 
		 * 
		 */		
		public override function getSkillDesc():String
		{
			var desc:String = super.getSkillDesc();
			
			return desc.replace("{0}", damage.toString());
		}
	}
}