using System;
using System.Collections;
using System.Reflection;

public class BuffFactory
{
	/// <summary>
	/// 通过反射获得一个Buff
	/// </summary>
	public static BaseBuff GetBuffByID(int id, int level)
	{
		BuffData buffData = DataManager.GetInstance().buffData[id];
		string className = "Buff" + buffData.templateID;
		Object obj = Activator.CreateInstance(Type.GetType(className), buffData, level);
		return obj as BaseBuff;
	}
}
