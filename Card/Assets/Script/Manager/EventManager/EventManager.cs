using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 事件管理器
/// </summary>
public class EventManager
{
	// 监听委托
    public delegate void Callback(GEvent e);
    private static Dictionary<string, List<Callback>> dict = new Dictionary<string, List<Callback>>();
	
	/// <summary>
	/// 加入一个侦听
	/// </summary>
    public static void AddListener(string type, Callback fn)
    {
        //如果不存在就创建一个字典  
        if (!dict.ContainsKey(type))
        {
            dict.Add(type, new List<Callback>());
        }

        if (!dict[type].Contains(fn))
        {
            return;
        }

        dict[type].Add(fn);
    }


    /// <summary>
	/// 删除一个类型的，一个指定回调
    /// </summary>
    public static void RemoveListener(string type, Callback fn)
    {
        if (dict.ContainsKey(type) && dict[type].Contains(fn))
        {
            List<Callback> list = dict[type] as List<Callback>;

            list.Remove(fn);

            if (list.Count <= 0)
            {
                dict.Remove(type);
            }
        }
    }

    /// <summary>
	/// 将一个类型的事件都删除
    /// </summary>
    public static void RemoveListenerByType(string type)
    {
        if (dict.ContainsKey(type))
        {
            dict.Remove(type);
        }
    }

    /// <summary>
	/// 发出一个事件，简化操作
    /// </summary>
    public static void Send(string type, object data = null)
    {
        GEvent e = new GEvent(type, data);
        SendEvent(e);
    }

    /// <summary>
	/// 发出一个事件
    /// </summary>
    public static void SendEvent(GEvent e)
    {
        //如果存在这个事件
        if (dict.ContainsKey(e.type))
        {
            Callback[] list = (dict[e.type] as List<Callback>).ToArray();
            for (int i = 0; i < list.Length; i++)
            {
                list[i](e);
            }
        }
    }
}
