using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 技能攻击
/// </summary>
public class SkillStartAction : BaseAction
{
	// 技能ID
	public int skillID;

	// 被攻击对象
	public List<int> target;

	SkillStartAction(int attacker, int skillID, List<int> targets)
	{
		type = ActionType.SkillStart;
		sourceID = attacker;
		this.skillID = skillID;
		this.target = target;
	}
	
	public override string ToString()
	{
		return string.Format("{0}释放了{1}技能", sourceID, skillID);
	}
	
	/// <summary>
	/// 获得一个行动
	/// </summary>
	public static SkillStartAction GetAction(int attacker, int skillID, List<int> targets)
	{
		return new SkillStartAction(attacker, skillID, targets);
	}
}
