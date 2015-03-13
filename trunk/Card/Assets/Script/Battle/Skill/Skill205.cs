using UnityEngine;
using System.Collections;

/// <summary>
/// 收到普通攻击时,最多收到100点伤害
/// </summary>
public class Skill205 : BaseSkill
{
	// 最高伤害
	int maxHurt;
	
	public Skill205(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		maxHurt = skillData.param1 * skillLevel;
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);
		
		card.AddEventListener(BattleEventType.ON_PRE_ATTACK_HURT, OnPreAttackHurt);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnPreAttackHurt);
		
		base.RemoveCard(card);
	}
	
	// 最高受到伤害
	void OnPreAttackHurt(FighterEvent e)
	{
		card.lastHurtValue = Mathf.Min(maxHurt, card.lastHurtValue);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
	}
}
