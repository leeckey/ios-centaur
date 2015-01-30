using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 事件参数
/// </summary>
public class GEvent
{
    public string type = "";
    public object data;

	/// <summary>
	/// 构造函数
	/// </summary>
    public GEvent(string _type, object _data = null)
    {
        type = _type;
        data = _data;
    }
}