using UnityEngine;
using System.Collections;

/// <summary>
/// 免疫技能
/// </summary>
public class Skill207 : BaseSkill
{

	public Skill207(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);

		card.canDoSkill = false;
		card.AddEventListener(BattleEventType.ON_CHECK_IMMUNE, OnCheckImmune);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.canDoSkill = true;
		card.RemoveEventListener(BattleEventType.ON_CHECK_IMMUNE, OnCheckImmune);

		base.RemoveCard(card);
	}
	
	// 最高受到伤害
	void OnCheckImmune(FighterEvent e)
	{
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
	}
}
