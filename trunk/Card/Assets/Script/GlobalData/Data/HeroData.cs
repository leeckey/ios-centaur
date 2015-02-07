using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 玩家数据
/// </summary>
[Serializable]
public class HeroData
{
	public string heroID;
	public string name;
	public int level;
	public int money;
	public int gem;
	public int icon;

	public HeroData()
	{
		heroID = "88888";
		name = "mickey";
		level  = 1;
		money = 10000;
		gem = 10000;
		icon = 1;
	}

}
