package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	
	/**
	 * 群体削弱：降低对方所有卡牌40点攻击力
	 * @author liq
	 * 
	 */	
	public class Skill_103 extends BaseSkill
	{
		/**
		 * 减少的攻击力 
		 */		
		public var deAttack:int;
		
		public function Skill_103(data:SkillData, card:BaseCardObj)
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
			
			deAttack = data.param1;
		}
		
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			targetCard.deductAttack(deAttack);
		}
	}
}