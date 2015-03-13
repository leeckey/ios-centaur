using UnityEngine;
using System.Collections;

/// <summary>
/// 火球,对随机对方一人或多人造成100-300点伤害
/// </summary>
public class Skill102 : BaseSkill
{
	// 最小攻击力
	public int min;

	// 最大攻击力
	public int max;


	public Skill102(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig (skillData);

		min = skillData.param1 * skillLevel;
		max = skillData.param2 * skillLevel;
	}

	protected override void _DoSkill(BaseFighter target)
	{
		int damage = Random.Range(min, max + 1);

		// 卡牌存在,攻击卡牌
		target.OnSkillHurt(this, damage);
	}
}
