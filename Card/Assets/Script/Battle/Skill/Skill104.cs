using UnityEngine;
using System.Collections;

/// <summary>
/// 群体削弱：降低对方所有卡牌5点攻击力
/// </summary>
public class Skill104 : BaseSkill
{
	// 降低的攻击力
	public int deAttack;

	public Skill104(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig (skillData);
		
		deAttack = skillLevel * skillData.param1;
	}

	// 减少攻击力
	protected override void _DoSkill(BaseFighter target)
	{
		if (target.CanDoSkill())
			target.DeductAttack(deAttack);
	}
}
