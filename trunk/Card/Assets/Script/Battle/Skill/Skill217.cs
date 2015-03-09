using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 王国守护:提升除自己之外所有王国卡牌200点生命值
/// </summary>
public class Skill217 : BaseSkill
{
	// 提升攻击力的概率
	int hpUp;
	
	public Skill217(Card card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		hpUp = skillData.param1 * skillLevel;
	}
	
	public override void RegisterCard(Card card)
	{
		base.RegisterCard(card);
		
		card.AddEventListener(BattleEventType.ON_CARD_PRESENT, OnPresent);
	}
	
	public override void RemoveCard(Card card)
	{
		card.RemoveEventListener(BattleEventType.ON_CARD_PRESENT, OnPresent);
		
		card.RemoveEventListener(BattleEventType.ON_CARD_DEAD, OnDead);
		
		base.RemoveCard(card);
	}
	
	// 给同国家的卡牌加攻击
	void OnPresent(FighterEvent e)
	{
		card.AddEventListener(BattleEventType.ON_CARD_DEAD, OnDead);
		
		List<BaseFighter> targetList = card.owner.GetTargetByType(card, TargetType);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(targetList)));
		if (targetList != null || targetList.Count == 0)
			return;
		
		// 在场的同国家增加攻击力
		foreach (Card target in targetList)
		{
			target.AddMaxHp(hpUp);
		}
		
		// 不在场的增加出场回调
		targetList = card.owner.GetTargetByCountry(card.cardData.country);
		foreach (Card target in targetList)
		{
			if (target == card)
				continue;
			
			target.AddEventListener(BattleEventType.ON_CARD_PRESENT, OnOtherCardPresent);
		}
	}

	void OnOtherCardPresent(FighterEvent e)
	{
		Card target = e.fighter as Card;
		if (target == null)
			return;
		
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(target)));
		target.AddMaxHp(hpUp);
	}
	
	// 死亡后还原最大血量
	void OnDead(FighterEvent e)
	{
		card.RemoveEventListener(BattleEventType.ON_CARD_DEAD, OnDead);
		
		List<BaseFighter> targetList = card.owner.GetTargetByType(card, TargetType);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(targetList)));
		if (targetList != null || targetList.Count == 0)
			return;
		
		// 在场的同国家增加血量上限
		foreach (Card target in targetList)
		{
			target.DeductMaxHp(hpUp);
		}
		
		// 不在场的增加出场回调
		targetList = card.owner.GetTargetByCountry(card.cardData.country);
		foreach (Card target in targetList)
		{
			if (target == card)
				continue;
			
			target.RemoveEventListener(BattleEventType.ON_CARD_PRESENT, OnOtherCardPresent);
		}
	}
}
