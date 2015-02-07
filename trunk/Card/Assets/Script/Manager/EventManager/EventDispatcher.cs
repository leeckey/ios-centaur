using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

/// <summary>
/// 事件发送基类
/// </summary>
public class EventDispatcher<T> where T : GEvent, new()
{
	// 回调委托
	public delegate void Callback(T e);

	// 事件字典
    private Dictionary<string, List<Callback>> dict;

	// 构造函数
    public EventDispatcher()
	{
        dict = new Dictionary<string, List<Callback>>();
    }

	/// <summary>
	/// 增加一个回调
	/// </summary>
    public void AddEventListener(string type, Callback fn)
    {
        //如果不存在就创建一个字典  
        if (!dict.ContainsKey(type))
        {
            dict.Add(type, new List<Callback>());
        }
        if (dict[type].Contains(fn))
        {
            return;
        }
        dict[type].Add(fn);
    }

    /// <summary>
	/// 删除一个类型的，一个指定回调
    /// </summary>
    public void RemoveEventListener(string type, Callback fn)
    {
        if (dict.ContainsKey(type) && dict[type].Contains(fn))
        {
            dict[type].Remove(fn);
        }

    }
    
	/// <summary>
	/// 将一个类型的事件都删除
	/// </summary>
    public void RemoveEventListenerByType(string type)
    {
        if (dict.ContainsKey(type))
        {
            dict.Remove(type);
        }
    }

	/// <summary>
	/// 指定事件是否存在
	/// </summary>
    public bool HasEventListener(string type)
    {
        if(dict.ContainsKey(type))
		{
            return true;
        }

        return false;
    }

    /// <summary>
	/// 发出一个事件
    /// </summary>
    public virtual void DispatchEvent(string type, object data = null)
    {
        T e = new T();
		e.SetParam(type, data);
        DispatchEvent(e);
    }

	public void DispatchEvent(T e)
    {
        //如果存在这个事件
        if (dict.ContainsKey(e.type))
        {
            List<Callback> list = (dict[e.type] as List<Callback>).ToList();
            foreach (Callback call in list)
            {
				call(e);
            }
        }
    }
}
