using UnityEngine;
using System.Collections;

/// <summary>
/// 诅咒技能,扣除对方英雄生命值
/// </summary>
public class Skill106 : BaseSkill
{
	// 攻击伤害
	int damage;
	
	public Skill106(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig (skillData);
		
		damage = skillLevel * skillData.param1;
	}
	
	protected override void _DoSkill(BaseFighter target)
	{
		// 给自己加血
		target.OnSkillHurt(this, damage);
	}
}
