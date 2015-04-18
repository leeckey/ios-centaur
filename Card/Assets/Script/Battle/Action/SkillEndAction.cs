using UnityEngine;
using System.Collections;

/// <summary>
/// 释放技能结束
/// </summary>
public class SkillEndAction : BaseAction
{
	int skillID;

	SkillEndAction(int sourceID, int skillID)
	{
		type = ActionType.SkillEnd;
		this.sourceID = sourceID;
		this.skillID = skillID;
	}

	public override string ToString()
	{
		return string.Format("{0}释放技能{1}结束", sourceID, DataManager.GetInstance().skillData[skillID].name);
	}

	public static SkillEndAction GetAction(int sourceID, int skillID)
	{
		return new SkillEndAction(sourceID, skillID);
	}
}
