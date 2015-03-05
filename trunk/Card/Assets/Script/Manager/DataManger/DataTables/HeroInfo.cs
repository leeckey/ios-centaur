using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 玩家等级信息
/// </summary>
[Serializable]
public class HeroInfo : IDataTable
{
	// 配置属性
	public int level;
	public int totalExp;
	public int totalCost;
	public int hp;
	public int friendCount;

	public string GetFileName()
	{
		return "HeroInfo.txt";
	}

	// key值
	public int GetKey()
	{
		return level;
	}
}
