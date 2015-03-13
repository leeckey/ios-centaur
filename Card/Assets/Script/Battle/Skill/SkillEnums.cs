using UnityEngine;
using System.Collections;

/// <summary>
/// 技能释放对象类型
/// </summary>
public enum SkillTargetType
{
	TARGET_SELF_TYPE = 0,           // 自身
	TARGET_SELF_FRONT_TYPE = 1,     // 自身对面
	TARGET_SELF_FRONT3_TYPE = 2,    // 自身对面3个，左边各扩展一个
	TARGET_RANDOM_TYPE = 3,         // 随机一个
	TARGET_RANDOM2_TYPE = 4,        // 随机2个
	TARGET_RANDOM3_TYPE = 5,        // 随机3个
	TARGET_MIN_HP_TYPE = 6,         // 血量最少的一个 
	TARGET_MAX_LOSE_HP_TYPE = 7,    // 掉血最多的一个
	TARGET_ALL_TYPE = 8,            // 对方所有
	TARGET_ATTACKER_TYPE = 9,       // 攻击我的那个
	TARGET_RANDOM_CURE = 10,        // 随机一个可以治疗的目标
	TARGET_ALL_CURE = 11,           // 所有HP不满的卡牌
	TARGET_SAME_COUNTRY = 12,       // 除自己外相同国家的卡牌
	TARGET_SELF_HURT_TYPE = 13,     // 自身受伤状态
	TARGET_MY_HERO = 14,            // 自身英雄
	TARGET_ENEMY_HERO = 15,         // 对方英雄
	TARGET_COUNTRY_1 = 16,          // 第一类卡牌
	TARGET_COUNTRY_2 = 17,          // 第二类卡牌
	TARGET_COUNTRY_3 = 18,          // 第三类卡牌
	TARGET_COUNTRY_4 = 19,          // 第四类卡牌
	MAX_ROUND_WAIT = 20,            // 等待区中等待时间最长的卡牌
	NO_BUFF_RANDOM = 21,            // 随机1个没有相同buff的卡牌
	NO_BUFF_RANDOM2 = 22,           // 随机2个没有相同buff的卡牌
	NO_BUFF_RANDOM3 = 23,           // 随机3个没有相同buff的卡牌
	NO_BUFF_ALL = 24,               // 所有没有相同buff的卡牌
	TARGET_SELF_FRONT_OR_FIGHTER = 25,  // 对面卡牌或者对方英雄
	TARGET_SELF_FRONT3_OR_FIGHTER = 26 // 对面3卡牌或者对方英雄
}

public enum SkillTypeEnum
{
	SKILL_ATTACK_TYPE = 0,
	SKILL_ACTIVE_TYPE = 1,
	SKILL_PASSIVE_TYPE = 2
}

public enum SkillMagicEnum
{
	SKILL_PHYSICAL_TYPE = 0,
	SKILL_MAAGIC_TYPE = 1
}

/// <summary>
/// 卡牌国家
/// </summary>
public enum CardCountry
{
	CARD_COUNTRY_SHU = 1,
	CARD_COUNTRY_WEI = 2,
	CARD_COUNTRY_WU = 3,
	CARD_COUNTRY_QUN
}