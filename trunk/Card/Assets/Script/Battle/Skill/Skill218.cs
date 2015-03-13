using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 转生：死亡时有50%概率进入等待区 
/// </summary>
public class Skill218 : BaseSkill
{
	// 伤害比率
	int rate;
	
	public Skill218(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		rate = skillData.param1 + skillData.param2 * skillLevel;
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
	
	// 50%概率进入等待区
	void OnCardDead(FighterEvent e)
	{
		if (Random.Range(0, 100) < rate)
		{
			card.DoWait();
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
