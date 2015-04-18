using System;
using System.Collections;

/// <summary>
/// 所有动作的基类
/// </summary>
public class BaseAction
{
	// 操作类型
	public ActionType type;

	// 操作的对象
	public int sourceID;

	// 被操作的对象
	public int targetID;

	// 输出为字符串调试用
	public override string ToString()
	{
		return string.Empty;
	}
}

/// <summary>
/// 操作类型
/// </summary>
public enum ActionType
{
	None,          // 空类型
	RoundStart,    // 回合开始
	RoundEnd,      // 回合结束
	CardWait,      // 抽牌
	CardFight,      // 出牌
	CardDead,      // 卡牌死亡
	CardBack,      // 卡牌回到牌堆
	RemoveCard,    // 弃牌
	Attack,        // 攻击
	Damage,        // 受到伤害
	SkillStart,
	SkillEnd,
	BuffAdd,
	BuffRemove,
	AttackChange,
	Cure,
	MaxHpChange
}
