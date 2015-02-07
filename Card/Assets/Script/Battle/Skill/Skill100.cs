using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 普通攻击技能
/// </summary>
public class Skill100 : BaseSkill
{

	public Skill100(Card card) : base(card)
	{
		skillID = 100;
		targetType = (int)SkillTargetType.TARGET_SELF_FRONT_OR_FIGHTER;
	}

	public override void DoSkill()
	{
		if (card == null || card.IsDead || card.attack <= 0)
			return;
		
		List<BaseFighter> targets = card.owner.GetTargetByType(card, targetType);
		if (targets.Count > 0)
		{
			// 卡牌存在,攻击卡牌
			card.owner.Room.actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(targets)));
			targets[0].OnAttackHurt(card, card.attack);
			card.owner.Room.actions.Add(SkillEndAction.GetAction(card.ID, skillID));
		}
	}

}
