using UnityEngine;
using System.Collections;

/// <summary>
/// 攻击变化的事件
/// </summary>
public class AttackChangeAction : BaseAction
{
	// 变化值
	public int num;
	
	AttackChangeAction(int target, int num)
	{
		type = ActionType.AttackChange;
		targetID = target;
		this.num = num;
	}
	
	public override string ToString()
	{
		return string.Format("{0}攻击力变化了{1}", sourceID, num);
	}
	
	/// <summary>
	/// 获得一个行动
	/// </summary>
	public static AttackChangeAction GetAction(int attacker, int num)
	{
		return new AttackChangeAction(attacker, num);
	}
}
