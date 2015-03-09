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
	
	BuffAddAction(int attacker, int skillID)
	{
		type = ActionType.SkillStart;
		sourceID = attacker;
		this.buffID = skillID;
	}
	
	public override string ToString()
	{
		return string.Format("{0}加上了{1}Buff", sourceID, buffID);
	}
	
	/// <summary>
	/// 获得一个行动
	/// </summary>
	public static BuffAddAction GetAction(int attacker, int skillID)
	{
		return new BuffAddAction(attacker, skillID);
	}
}
