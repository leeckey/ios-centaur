package centaur.data.skill
{
	public final class SkillEnumDefines
	{
		// 技能类型
		public static const SKILL_ATTACK_TYPE:int = 0;		    // 普通攻击技能
		public static const SKILL_ACTIVE_TYPE:int = 1;		    // 主动技能
		public static const SKILL_PASSIVE_TYPE:int = 2;		    // 被动技能

		public static const SKILL_PHYSICAL_TYPE:int = 0;          // 物理技能
		public static const SKILL_MAAGIC_TYPE:int = 1;            // 法术技能
		
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
		public static const TARGET_RANDOM2_TYPE:int = 4;		    // 随机2个
		public static const TARGET_RANDOM3_TYPE:int = 5;		    // 随机3个
		public static const TARGET_MIN_HP_TYPE:int = 6;		    // 血量最少的一个 
		public static const TARGET_MAX_LOSE_HP_TYPE:int = 7;	    // 掉血最多的一个
		public static const TARGET_ALL_TYPE:int = 8;			    // 对方所有
		public static const TARGET_ATTACKER_TYPE:int = 9;		    // 攻击我的那个
		public static const TARGET_RANDOM_CURE:int = 10;          // 己方血量最低的卡牌
		public static const TARGET_ALL_CURE:int = 11;             // 所有HP不满的卡牌
		public static const TARGET_SAME_COUNTRY:int = 12;         // 除自己外相同国家的卡牌
		public static const TARGET_SELF_HURT_TYPE:int = 13;       // 自身受伤状态
		public static const TARGET_MY_HERO:int = 14;              // 自身英雄
		public static const TARGET_ENEMY_HERO:int = 15; 			// 对方英雄
		public static const TARGET_COUNTRY_1:int = 16; 			// 第一类卡牌
		public static const TARGET_COUNTRY_2:int = 17; 			// 第二类卡牌
		public static const TARGET_COUNTRY_3:int = 18; 			// 第三类卡牌
		public static const TARGET_COUNTRY_4:int = 19; 			// 第四类卡牌
		public static const MAX_ROUND_WAIT:int = 20;            // 等待区中等待时间最长的卡牌
		public static const NO_BUFF_RANDOM:int = 21;            // 随机1个没有相同buff的卡牌
		public static const NO_BUFF_RANDOM2:int = 22;            // 随机2个没有相同buff的卡牌
		public static const NO_BUFF_RANDOM3:int = 23;            // 随机3个没有相同buff的卡牌
		public static const NO_BUFF_ALL:int = 24;            // 所有没有相同buff的卡牌
		
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