using UnityEngine;
using System.Collections;

/// <summary>
/// 反击：受到物理攻击时，立刻反击造成100点伤害
/// </summary>
public class Skill210 : BaseSkill
{
	// 反击的伤害
	int damage;
	
	public Skill210(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
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
		
		card.AddEventListener(BattleEventType.ON_AFTER_ATTACK_HURT, OnAfterAttackHurt);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_AFTER_ATTACK_HURT, OnAfterAttackHurt);
		
		base.RemoveCard(card);
	}
	
	// 受攻击前减少伤害
	void OnAfterAttackHurt(FighterEvent e)
	{
		if (card.attacker != null && !card.attacker.IsDead)
		{
			card.attacker.OnHurt(damage);
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
