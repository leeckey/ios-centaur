using UnityEngine;
using System.Collections;

/// <summary>
/// 反射技能,魔法伤害无效,并对攻击方造成120点伤害
/// </summary>
public class Skill203 : BaseSkill
{
	// 减少的伤害
	int damage;
	
	public Skill203(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
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
		
		card.AddEventListener(BattleEventType.ON_PRE_SKILL_HURT, OnPreSkillHurt);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_PRE_SKILL_HURT, OnPreSkillHurt);
		
		base.RemoveCard(card);
	}
	
	// 魔法伤害无效,给攻击者反射伤害
	void OnPreSkillHurt(FighterEvent e)
	{
		if (card.attackSkill.SkillType != (int)SkillMagicEnum.SKILL_MAAGIC_TYPE)
			return;

		card.lastAttackValue = 0;

		if (card.attacker != null && !card.attacker.IsDead)
		{
			card.attacker.OnHurt(damage);
		}

		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
	}
}
