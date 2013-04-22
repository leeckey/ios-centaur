package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	
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
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;
			
			targetCard.addHP(cure);
		}
	}
}