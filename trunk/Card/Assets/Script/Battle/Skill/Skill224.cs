using UnityEngine;
using System.Collections;

/// <summary>
/// 不受摧毁,送还,传送技能影响
/// </summary>
public class Skill224 : BaseSkill
{

	public Skill224(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);
		
		card.canBeMove = false;
		card.AddEventListener(BattleEventType.ON_CHECK_MOVE, OnCheckMove);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.canBeMove = true;
		card.RemoveEventListener(BattleEventType.ON_CHECK_MOVE, OnCheckMove);
		
		base.RemoveCard(card);
	}
	
	// 最高受到伤害
	void OnCheckMove(FighterEvent e)
	{
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
	}
}
