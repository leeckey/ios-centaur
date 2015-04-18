using UnityEngine;
using System.Collections;

/// <summary>
/// 收到治疗
/// </summary>
public class CureNotifyAction : BaseAction
{
	// 收到的伤害
	public int cure;
	
	CureNotifyAction(int target, int cure)
	{
		type = ActionType.Cure;
		// sourceID = attacker;
		targetID = target;
		this.cure = cure;
	}
	
	public override string ToString()
	{
		return string.Format("{0}受到{1}治疗", targetID, cure);
	}
	
	/// <summary>
	/// 获得一个行动
	/// </summary>
	public static CureNotifyAction GetAction(int target, int cure)
	{
		return new CureNotifyAction(target, cure);
	}
}
