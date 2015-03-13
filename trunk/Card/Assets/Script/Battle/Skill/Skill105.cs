using UnityEngine;
using System.Collections;

/// <summary>
/// 治疗技能
/// </summary>
public class Skill105 : BaseSkill
{
	// 攻击伤害
	int cure;
	
	public Skill105(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig (skillData);
		
		cure = skillLevel * skillData.param1;
	}
	
	protected override void _DoSkill(BaseFighter target)
	{
		// 给自己加血
		target.AddHp(cure);
	}
}
