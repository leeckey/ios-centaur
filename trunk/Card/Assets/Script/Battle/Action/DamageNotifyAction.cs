using UnityEngine;
using System.Collections;

/// <summary>
/// 造成伤害
/// </summary>
public class DamageNotifyAction : BaseAction
{
	// 收到的伤害
	public int damage;

	DamageNotifyAction(int target, int damage)
	{
		type = ActionType.Damage;
		// sourceID = attacker;
		targetID = target;
		this.damage = damage;
	}

	public override string ToString()
	{
		return string.Format("{0}受到{1}伤害", targetID, damage);
	}

	/// <summary>
	/// 获得一个行动
	/// </summary>
	public static DamageNotifyAction GetAction(int target, int damage)
	{
		return new DamageNotifyAction(target, damage);
	}
}
