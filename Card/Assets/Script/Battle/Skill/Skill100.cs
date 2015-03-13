using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 普通攻击技能
/// </summary>
public class Skill100 : BaseSkill
{
	public Skill100(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{

	}

	protected override void _DoSkill(BaseFighter target)
	{
		if (card.Attack <= 0)
			return;

		// 卡牌存在,攻击卡牌
		target.OnAttackHurt(card, card.Attack);
	}

}
