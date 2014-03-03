package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	
	/**
	 * 群体削弱：降低对方所有卡牌5点攻击力
	 * @author liq
	 * 
	 */	
	public class Skill_103 extends BaseSkill
	{
		/**
		 * 减少的攻击力 
		 */		
		public var deAttack:int;
		
		public function Skill_103(data:SkillData, card:BaseCardObj, skillPara:Array)
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
			
			deAttack = data.param1 * skillLevel;
		}
		
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			if (targetCard.onSkillHurt(this, 0) >= 0)
				targetCard.deductAttack(deAttack);
		}
		
		/**
		 * 显示技能描述 
		 * @return 
		 * 
		 */		
		public override function getSkillDesc():String
		{
			var desc:String = super.getSkillDesc();
			
			return desc.replace("{0}", deAttack.toString());
		}
	}
}