using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// Buff信息
/// </summary>
[Serializable]
public class BuffData : IDataTable
{
	// 配置属性
	public int id;
	public int templateID;
	public string name;
	public string effectPath;
	public string discription;
	public int param1;
	public int round;
	public int superposition;
	
	public string GetFileName()
	{
		return "BuffData.txt";
	}
	
	// key值
	public int GetKey()
	{
		return id;
	}
}
