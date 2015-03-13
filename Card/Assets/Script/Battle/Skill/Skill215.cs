using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 自爆：被消灭时，对对面以及相邻三张卡牌造成100点伤害
/// </summary>
public class Skill215 : BaseSkill
{
	// 伤害比率
	int damage;

	public Skill215(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{

	}

	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);

		damage = skillData.param1 * skillLevel;
	}

	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);

		card.AddEventListener(BattleEventType.ON_CARD_DEAD, OnCardDead);
	}

	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_CARD_DEAD, OnCardDead);

		base.RemoveCard(card);
	}

	// 对对面以及相邻三张卡牌造成100点伤害
	void OnCardDead(FighterEvent e)
	{
		List<BaseFighter> targetList = card.owner.GetTargetByType(this, TargetType);
		if (targetList != null || targetList.Count == 0)
			return;

		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(targetList)));
		foreach (CardFighter target in targetList)
		{
			if (target.CanDoSkill() && !target.IsDead)
				target.OnHurt(damage);
		}
	}
}
