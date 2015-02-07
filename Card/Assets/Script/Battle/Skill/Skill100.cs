using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 普通攻击技能
/// </summary>
public class Skill100 : BaseSkill
{
//	public Skill100(Card card) : base(card)
//	{
//		skillID = 100;
//		// TargetType = (int)SkillTargetType.TARGET_SELF_FRONT_OR_FIGHTER;
//	}

	protected override void _DoSkill(BaseFighter target)
	{
		if (card.attack <= 0)
			return;

		// 卡牌存在,攻击卡牌
		target.OnAttackHurt(card, card.attack);
	}

}
