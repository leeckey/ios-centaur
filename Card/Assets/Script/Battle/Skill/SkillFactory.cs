using System;
using System.Collections;
using System.Reflection;

public class SkillFactory
{
	/// <summary>
	/// 通过反射获得一个技能
	/// </summary>
	public static BaseSkill GetSkillByID(int id, CardFighter card, int[] skillParam = null)
	{
		SkillData skillData = DataManager.GetInstance().skillData[id];
		string className = "Skill" + skillData.templateID;
		Object obj = Activator.CreateInstance(Type.GetType(className), card, skillData, skillParam);
		return obj as BaseSkill;
	}

	/// <summary>
	/// 获得基础攻击技能
	/// </summary>
	public static BaseSkill GetAttackSkill(CardFighter card)
	{
		return GetSkillByID(1, card, null);
	}
}
