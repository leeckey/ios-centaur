package centaur.data.skill
{
	/**
	 *   技能相关数据
	 */ 
	public final class SkillData
	{
		// 基础属性
		public var templateID:uint;			// 模板ID
		public var name:String;				// 技能名称
		public var script:String;			// 脚本名称
		public var effectPath:String;		// 技能效果资源
		public var discription:String;		// 技能描述
		public var skillType:int;			// 技能的类型，主动法术伤害（包括加血），物理伤害(包括吸血)，被动防御技能，特殊辅助技能,死契技能，降临技能
		public var selectTargetType:int;	// 选择目标的类型，单选，随机多选,目标两边扩散3选,血量最小目标，所有目标等
		public var isAffectSelf:Boolean;	// 目标是己方还是对方
		public var damage:Number = 0;		// 技能伤害量,>0表示受伤害，<0表示加血      
											// -1~1之间表示百分比，不是定值,>1||<-1表示定值,下同
		public var vampireRatio:int;		// 吸取伤害的比率
		
		// 法术伤害,物理伤害相关属性
		public var buffPath:String;			// BUFF效果资源
		public var buffType:int; 			// BUFF结算阶段，目前分回合开始时，技能释放时，物理攻击时，回合结束时等等
		public var durationRound:int;		// 持续回合数
		public var durationDamage:Number = 0;		// 持续伤害,>0表示受伤害，<0表示加血
		public var avoidBuffTypeRatio:int;	// 跳过当前Buff结算阶段的概率 0~100
		
		// 属性增减
		public var attackChange:int;		// 攻击属性改变
		public var hpChange:int;			// 生命属性改变
		
		// 被动技能相关属性
		public var avoidAttackDamageRatio:int;		// 闪避物理伤害的概率 <=0则无闪避
		public var avoidMagicDamageRatio:int;		// 闪避法术伤害的概率
		public var maxDamageWhenMagic:Number = -1;	// 当受到技能属性伤害时被动受最大伤害,后续扩展分不同属性伤害,0~1为百分比
		public var maxDamageWhenAttack:Number = -1;	// 当受到技能属性伤害时被动受最大伤害,后续扩展分不同属性伤害,0~1为百分比
		public var avoidMagicDamage:Boolean;		// 无视法术伤害
		public var avoidAttackDamage:Boolean;		// 无视物理伤害
		public var reduceMagicDamage:Number = 0;	// 豁免法术伤害值，减少伤害值
		public var reduceAttackDamage:Number = 0;	// 豁免物理伤害值，减少伤害值
		public var reflexMagicDamage:Number = 0;	// 反弹法术伤害值
		public var reflexAttackDamage:Number = 0;	// 反弹物理伤害值
		public var avoidTransToDie:Boolean;			// 无视传送到墓地区
		public var avoidTransToWait:Boolean;		// 无视传送到等待区
		public var avoidTransToCard:Boolean;		// 无视传送到卡堆区
		
		// 特殊技能相关属性
		public var specialType:int;					// 特殊技能的类型，大概分为送还，摧毁，回魂等，只有在技能为死契或降临时触发
		
		public function SkillData()
		{
		}
	}
}