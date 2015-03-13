using UnityEngine;
using System.Collections;

/// <summary>
/// 血炼：使对方一张卡牌受到100点伤害，并且自身恢复相同的生命值
/// </summary>
public class Skill103 : BaseSkill
{
	// 攻击伤害
	int damage;

	public Skill103(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig (skillData);

		damage = skillLevel * skillData.param1;
	}
	
	protected override void _DoSkill(BaseFighter target)
	{
		int hurt = target.OnSkillHurt(this, damage);

		// 给自己加血
		card.AddHp(hurt);
	}
}
