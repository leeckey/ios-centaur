using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 移除Buff
/// </summary>
public class BuffRemoveAction : BaseAction
{
	// BuffID
	public int buffID;
	
	BuffRemoveAction(int attacker, int skillID)
	{
		type = ActionType.BuffRemove;
		sourceID = attacker;
		this.buffID = skillID;
	}
	
	public override string ToString()
	{
		return string.Format("{0}的Buff{1}消失了", sourceID, buffID);
	}
	
	/// <summary>
	/// 获得一个行动
	/// </summary>
	public static BuffRemoveAction GetAction(int attacker, int skillID)
	{
		return new BuffRemoveAction(attacker, skillID);
	}
}
