package centaur.data.skill
{
	public final class SkillEnumDefines
	{
		// 技能类型
		public static const SKILL_ATTACK_TYPE:int = 0;		    // 普通攻击技能
		public static const SKILL_ACTIVE_TYPE:int = 1;		    // 主动技能
		public static const SKILL_PASSIVE_TYPE:int = 2;		    // 被动技能

		
		public static const SKILL2STR:Array = [
			"",
			"magicType",
			"attackType",
			"magicDefenseType",
			"attackDefenseType",
			"deathType",
			"presentType",
			"specDefenseType"
		];
		
		
		// 技能目标选择类型
		public static const TARGET_SELF_TYPE:int = 0;			    // 自身
		public static const TARGET_SELF_FRONT_TYPE:int = 1;		// 自身对面
		public static const TARGET_SELF_FRONT3_TYPE:int = 2;	    // 自身对面3个，左边各扩展一个
		public static const TARGET_RANDOM_TYPE:int = 3;		    // 随机一个
		public static const TARGET_RANDOM3_TYPE:int = 4;		    // 随机3个
		public static const TARGET_MIN_HP_TYPE:int = 5;		    // 血量最少的一个 
		public static const TARGET_MAX_LOSE_HP_TYPE:int = 6;	    // 掉血最多的一个
		public static const TARGET_ALL_TYPE:int = 7;			    // 对方所有
		public static const TARGET_ATTACKER_TYPE:int = 8;		    // 攻击我的那个
		public static const TARGET_RANDOM_CURE:int = 9;           // 己方血量最低的卡牌
		public static const TARGET_ALL_CURE:int = 10;             // 所有HP不满的卡牌
		public static const TARGET_SAME_COUNTRY:int = 11;         // 除自己外相同国家的卡牌
		
		// 特殊技能的类型
		public static const SPEC_COMBATTOCARD_TYPE:int = 1;			// 送还：将对面的卡牌送回卡组
		public static const SPEC_COMBATTOCEMETERY_TYPE:int = 2;		// 摧毁：将地方一张卡牌送入墓地
		public static const SPEC_SELFCEMETERYTOCARD_TYPE:int = 3; 	// 回魂：将我方墓地的一张卡牌送回牌堆
//		public static const SPEC_////----wangq  复活 回魂的区别？
		public static const SPEC_WAITTOCEMETERY_TYPE:int = 5;		// 传送：将对方等待区中等待时间最长的卡牌送入墓地
		
		// BUFF结算阶段类型
		public static const BUFF_ROUND_START:int = 1;				// 回合开始时BUFF生效
		public static const BUFF_SKILL_START:int = 2;				// 技能施法时BUFF生效
		public static const BUFF_ATTACK_START:int = 3;				// 普通攻击时BUFF生效
		public static const BUFF_ROUND_END:int = 4;					// 回合结束时BUFF生效
		
	}
}