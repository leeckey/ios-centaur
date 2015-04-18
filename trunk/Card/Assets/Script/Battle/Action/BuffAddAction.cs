using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 增加buff
/// </summary>
public class BuffAddAction : BaseAction
{
	// BuffID
	public int buffID;
	
	BuffAddAction(int target, int skillID)
	{
		type = ActionType.BuffAdd;
		sourceID = target;
		this.buffID = skillID;
	}
	
	public override string ToString()
	{
		return string.Format("{0}加上了{1}Buff", sourceID, sourceID, DataManager.GetInstance().buffData[buffID].name);
	}
	
	/// <summary>
	/// 获得一个行动
	/// </summary>
	public static BuffAddAction GetAction(int target, int skillID)
	{
		return new BuffAddAction(target, skillID);
	}
}
