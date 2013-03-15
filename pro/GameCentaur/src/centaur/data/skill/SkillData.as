package centaur.data.skill
{
	/**
	 *   技能相关数据
	 */ 
	public final class SkillData
	{
		public var templateID:uint;		// 模板ID
		public var name:String;			// 技能名称		
		public var effectPath:String;	// 技能效果资源
		public var dispription:String;	// 技能描述
		public var isInitiative:Boolean;// 是否为主动技
		public var damage:int;			// 技能伤害量
		public var selectTargetType:int;	// 选择目标的类型，单选，随机多选,目标两边扩散多选等，后续再说
		public var targetNum:int = 1;		// 目标数量
		
		public var isDurationSkill:Boolean; // 持续伤害类
		public var durationRound:int;		// 持续回合数
		
		public function SkillData()
		{
		}
	}
}