using System;

/// <summary>
/// 事件参数
/// </summary>
public class GEvent
{
    public string type = string.Empty;
    public object data;

	public GEvent()
	{
		type = string.Empty;
		data = null;
	}

	/// <summary>
	/// 构造函数
	/// </summary>
	public GEvent(string _type, object _data = null)
	{
		type = _type;
		data = _data;
	}

	/// <summary>
	/// 设置数据
	/// </summary>
    public virtual void SetParam(string _type, object _data = null)
    {
        type = _type;
        data = _data;
    }
}