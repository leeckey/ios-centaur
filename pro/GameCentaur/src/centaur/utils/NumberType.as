package centaur.utils
{
	/**
	 * 攻击动作结果类型
	 * @author Administrator
	 * 
	 */	
	public class NumberType
	{
		/**命中 */		
		public static const HIT:uint = 1;
		/**未命中*/		
		public static const MISS:uint = 2;
		/**格挡(我对他人)*/		
		public static const BLOCK:uint = 3;
		public static const BLOCK_SKILL:uint = 5;
		public static const BLOCK_SKILL_ME:uint = 6;		// 被攻击
		/**技能暴击(我对他人)*/		
		public static const CRITICAL_SKILL:uint = 7;
		/**他人对我的技能暴击*/		
		public static const CRITICAL_SKILL_ME:uint = 8;		// 被攻击
		/**普通技能攻击*/
		public static const NORMAL_SKILL:uint = 9;
		public static const NORMAL_SKILL_ME:uint = 10;		// 被攻击
		/**普通攻击*/
		public static const NORMAL_PHY:uint = 11;
		public static const NORMAL_PHY_ME:int = 12;
		/**普通攻击暴击*/
		public static const CRITICAL_PHY:uint = 13;
		/**加血*/		
		public static const ADDBLOOD:uint = 14;
		/** 击倒 */		
		public static const HITDOWN:uint = 15;
		/**斩*/		
		public static const CHOP:uint = 16;
		/** 人斩 */		
		public static const PERSONCHOP:uint = 17;
		/**持续掉血*/
		public static const BUFF_DAMAGE:uint = 18;
		
		/** 自身抵抗 */
		public static const SELF_RESIST:uint = 19;
		
		/** 其他人抵抗 */
		public static const OTHER_RESIST:uint = 20;
		/**战斗力*/
		public static const FIGHT_CHANGE_CUR:uint = 30;			// 金色
		public static const FIGHT_CHANGE_PLUS:uint = 31;		// 绿色
		public static const FIGHT_CHAGNE_MINUS:uint = 32;		// 红色
		/**加经验 */		
		public static const EXP:uint = 1000;
	}
}