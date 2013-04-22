package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	
	/**
	 * 火球,对随机对方一人或多人造成100-300点伤害 
	 * @author liq
	 * 
	 */	
	public class Skill_101 extends BaseSkill
	{
		/**
		 * 最小攻击力 
		 */		
		public var min:int
		
		/**
		 * 最大攻击力 
		 */		
		public var max:int;
		
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
			
			min = data.param1;
			max = data.param2;
		}
		
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			var damage:int = min + (max - min) * Math.random();
			targetCard.onSkillHurt(this, damage);
		}
	}
}