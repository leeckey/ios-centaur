using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 技能配置信息
/// </summary>
[Serializable]
public class SkillData : IDataTable
{
	public int id;
	public int templateID;
	public string name;
	public string effectPath;
	public string discription;
	public int skillType;
	public int magicType;
	public int priority;
	public int selectTargetType;
	public int param1;
	public int param2;
	public int param3;
	public int buffID;

	public string GetFileName()
	{
		return "SkillData.txt";
	}
	
	// key值
	public int GetKey()
	{
		return id;
	}

}
