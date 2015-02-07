using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 所有数据类的基类,必须实现的接口
/// </summary>
public interface IDataTable
{
	// 资源名称
	string GetFileName();

	// 资源Key值
	int GetKey();
}
