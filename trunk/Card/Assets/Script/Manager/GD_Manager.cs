using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 全局数据管理
/// </summary>
public class GD_Manager 
{
	static List<GD_Base> globalData = new List<GD_Base>();

	public static void Init()
	{
		globalData.Add(new GD_HeroInfo());

		// 初始化所有GD
		foreach (GD_Base gd in globalData)
			gd.Init();
	}
}
