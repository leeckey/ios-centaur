using UnityEngine;
using System.Collections;

/// <summary>
/// 受到普通攻击时,减少30点伤害 
/// </summary>
public class Skill202 : BaseSkill
{
	// 减少的伤害
	int defance;
	
	public Skill202(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);

		defance = skillData.param1 * skillLevel;
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
	
	// 受攻击前减少伤害
	void OnPreAttackHurt(FighterEvent e)
	{
		card.lastHurtValue = Mathf.Max(0, card.lastHurtValue - defance);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
	}

}
