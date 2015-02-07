using UnityEngine;
using System.Collections;

/// <summary>
/// 全局数据基类,提供基础的构造函数和清理函数
/// </summary>
public class GD_Base
{
	public GD_Base()
	{
		Init();
	}

	// 初始化
	public virtual void Init()
	{
		Load();
	}

	// 保存数据
	public virtual void Save()
	{

	}

	// 读取数据
	public virtual void Load()
	{

	}
}
