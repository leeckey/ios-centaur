using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 王国之力：提升除自己之外所有蜀国卡牌100点攻击力
/// </summary>
public class Skill216 : BaseSkill
{
	// 提升攻击力的概率
	int attackUp;
	
	public Skill216(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		attackUp = skillData.param1 * skillLevel;
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);
		
		card.AddEventListener(BattleEventType.ON_CARD_PRESENT, OnPresent);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_CARD_PRESENT, OnPresent);
		
		card.RemoveEventListener(BattleEventType.ON_CARD_DEAD, OnDead);
		
		base.RemoveCard(card);
	}
	
	// 给同国家的卡牌加攻击
	void OnPresent(FighterEvent e)
	{
		card.AddEventListener(BattleEventType.ON_CARD_DEAD, OnDead);

		List<BaseFighter> targetList = card.owner.GetTargetByType(this, TargetType);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(targetList)));
		if (targetList != null || targetList.Count == 0)
			return;

		// 在场的同国家增加攻击力
		foreach (CardFighter target in targetList)
		{
			target.AddAttack(attackUp);
		}

		// 不在场的增加出场回调
		targetList = card.owner.GetTargetByCountry(card.cardData.country);
		foreach (CardFighter target in targetList)
		{
			if (target == card)
				continue;

			target.AddEventListener(BattleEventType.ON_CARD_PRESENT, OnOtherCardPresent);
		}
	}
	
	void OnOtherCardPresent(FighterEvent e)
	{
		CardFighter target = e.fighter as CardFighter;
		if (target == null)
			return;

		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(target)));
		target.AddAttack(attackUp);
	}

	// 死亡后还原攻击
	void OnDead(FighterEvent e)
	{
		card.RemoveEventListener(BattleEventType.ON_CARD_DEAD, OnDead);

		List<BaseFighter> targetList = card.owner.GetTargetByType(this, TargetType);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(targetList)));
		if (targetList != null || targetList.Count == 0)
			return;
		
		// 在场的同国家增加攻击力
		foreach (CardFighter target in targetList)
		{
			target.DeductAttack(attackUp);
		}
		
		// 不在场的增加出场回调
		targetList = card.owner.GetTargetByCountry(card.cardData.country);
		foreach (CardFighter target in targetList)
		{
			if (target == card)
				continue;

			target.RemoveEventListener(BattleEventType.ON_CARD_PRESENT, OnOtherCardPresent);
		}
	}
}
