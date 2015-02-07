using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 游戏初始化
/// </summary>
public class GameMain : MonoBehaviour
{
	// 是否初始化完成
	public static bool isInit = false;

	void Awake()
	{
		// 已经初始化过了
		if (isInit)
			return;

		StartCoroutine(GameInit());
	}

	// 开始初始化游戏
	IEnumerator GameInit()
	{
		yield return null;

		// 初始化数据
		DataManager.GetInstance().Init();

		yield return null;

		// 初始化全局数据
		GD_Manager.Init();

		// 模拟等待2秒
		yield return new WaitForSeconds(2f);

		yield return null;

		isInit = true;
	}
}


