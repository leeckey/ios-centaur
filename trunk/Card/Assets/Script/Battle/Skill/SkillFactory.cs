using System;
using System.Collections;
using System.Reflection;

public class SkillFactory
{
	/// <summary>
	/// 通过反射获得一个技能
	/// </summary>
	public static BaseSkill GetSkillByID(int id, Card card)
	{
		string className = "Skill" + id;
		Object obj = Activator.CreateInstance(Type.GetType(className), card);
		return obj as BaseSkill;
	}
}
