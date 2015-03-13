using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 
/// </summary>
public class Skill200 : BaseSkill
{
	public Skill200(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);

		card.attackSkill = this;
	}

	public override void RemoveCard(CardFighter card)
	{
		base.RemoveCard(card);

		card.attackSkill = SkillFactory.GetAttackSkill(card);
	}

	/// <summary>
	/// 横扫技能效果,中间卡牌收到的伤害作为旁边二张卡牌的攻击力
	/// </summary>
	public override void DoSkill()
	{
		if (card == null || card.IsDead || card.Attack <= 0)
			return;
		
		List<BaseFighter> targetList = card.owner.GetTargetByType(this, TargetType);
		
		if (targetList.Count == 0)
			return;
		
		List<int> cardIDs = GetTargetID(targetList);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, cardIDs));

		BaseFighter fighter = targetList[0];
		int damage = fighter.OnAttackHurt(card, card.Attack);

		for (int i = 1; i < targetList.Count; i++)
		{
			fighter = targetList[i];
			fighter.OnAttackHurt(card, damage);
		}

		// card.Actions.Add(SkillEndAction.GetAction(card.ID, skillID));
	}
}
