using System;

public class BattleEventType
{
	// 卡牌出场事件
	public static string ON_CARD_PRESENT = "ON_CARD_PRESENT";

	// 普通攻击前事件
	public static string ON_PRE_ATTACK = "ON_PRE_ATTACK";

	// 普通攻击后事件
	public static string ON_AFTER_ATTACK = "ON_AFTER_ATTACK";

	// 伤害攻击前事件
	public static string ON_PRE_ATTACK_HURT = "ON_PRE_ATTACK_HURT";

	// 伤害攻击后事件
	public static string ON_AFTER_ATTACK_HURT = "ON_AFTER_ATTACK_HURT";

	// 攻击成功消息
	public static string ON_ATTACK_SUCC = "ON_ATTACK_SUCC";

	// 技能伤害后事件
	public static string ON_AFTER_SKILL_HURT = "ON_AFTER_SKILL_HURT";

	// 技能伤害前事件
	public static string ON_PRE_SKILL_HURT = "ON_PRE_SKILL_HURT";

	// 技能攻击成功
	public static string ON_SKILL_ATTACK_SUCC = "ON_SKILL_ATTACK_SUCC";

	// 检测是否免疫技能
	public static string ON_CHECK_IMMUNE = "ON_CHECK_IMMUNE";

	// 是否可被位移
	public static string ON_CHECK_MOVE = "ON_CHECK_MOVE";

	// 卡牌死亡消息
	public static string ON_CARD_DEAD = "ON_CARD_DEAD";

	// 回合开始
	public static string ON_ROUND_START = "ON_ROUND_START";

	// 回合结束
	public static string ON_ROUND_END = "ON_ROUND_END";
}
