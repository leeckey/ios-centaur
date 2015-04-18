using UnityEngine;
using System.Collections;

/// <summary>
/// 最大血量变化
/// </summary>
public class MaxHpChangeAction : BaseAction
{
	// 变化值
	public int num;
	
	MaxHpChangeAction(int target, int num)
	{
		type = ActionType.MaxHpChange;
		targetID = target;
		this.num = num;
	}
	
	public override string ToString()
	{
		return string.Format("{0}最大血量变化了{1}", sourceID, num);
	}
	
	/// <summary>
	/// 获得一个行动
	/// </summary>
	public static MaxHpChangeAction GetAction(int target, int num)
	{
		return new MaxHpChangeAction(target, num);
	}
}
