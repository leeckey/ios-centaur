package centaur.data.skill
{
	/**
	 *   技能相关数据
	 */ 
	public final class SkillData
	{
		// 基础属性
		public var id:uint;			        // 技能ID
		public var templateID:uint             // 模板ID
		public var name:String;				// 技能名称
		public var effectPath:String;		    // 技能效果资源
		public var discription:String;		    // 技能描述
		public var skillType:int;			    // 技能的类型，主动法术伤害（包括加血），物理伤害(包括吸血)，被动防御技能，特殊辅助技能,死契技能，降临技能
		public var magicType:int;			    // 魔法类型,0:物理,1:法术
		public var priority:int;	            // 技能优先级
		public var selectTargetType:int;       // 技能攻击类型
		public var param1:int;                 // 技能参数1
		public var param2:int;                 // 技能参数2
		public var param3:int;                 // 技能参数3
		public var buffID:int;                 // buffID
		public var buffLevel:int;              // buff级别
		
		public var skillLevel:int;             // 技能等级,动态设置
		
		public function SkillData()
		{
		}
		
	}
}