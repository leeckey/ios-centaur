using System;
using System.Collections;
using System.Reflection;

public class SkillFactory
{
	/// <summary>
	/// 通过反射获得一个技能
	/// </summary>
	public static BaseSkill GetSkillByID(int id, Card card, int[] skillParam)
	{
		SkillData skillData = DataManager.GetInstance().skillData[1];
		string className = "Skill" + skillData.templateID;
		Object obj = Activator.CreateInstance(Type.GetType(className), card, skillData, skillParam);
		return obj as BaseSkill;
	}

	/// <summary>
	/// 获得基础攻击技能
	/// </summary>
	public static BaseSkill GetAttackSkill(Card card)
	{
		return GetSkillByID(1, card, null);
	}
}
