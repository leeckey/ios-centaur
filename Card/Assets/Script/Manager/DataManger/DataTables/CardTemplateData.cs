using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 卡牌配置信息
/// </summary>
[Serializable]
public class CardTemplateData : IDataTable
{
	public int templateID;
	public string name;
	public int baseHP;
	public int growUpHP;
	public int baseACK;
	public int growUpACK;
	public int defense;
	public int maxWaitRound;
	public int normolAttID;
	public int skill1ID;
	public string skill1Para;
	public int skill2ID;
	public string skill2Para;
	public int skill3ID;
	public string skill3Para;
	public int starLv;
	public int country;
	public int cost;


	public string GetFileName()
	{
		return "CardTemplateData.txt";
	}

	// key值
	public int GetKey()
	{
		return templateID;
	}

	// 获得技能参数
	public int[] GetSkillPara(int index)
	{
		string skillPara = string.Empty;
		switch (index)
		{
		case 1:
			skillPara = skill1Para;
			break;
		case 2:
			skillPara = skill2Para;
			break;
		case 3:
			skillPara = skill3Para;
			break;
		}

		string[] temp = skillPara.Split(',');
		List<int> result = new List<int>();
		for (int i = 0; i < temp.Length; i++)
		{
			result.Add(int.Parse(temp[i]));
		}
		return result.ToArray();
	}
}
