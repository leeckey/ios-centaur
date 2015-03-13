using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 盾刺:当受到物理伤害时,立即反击攻击者及相邻卡牌并给予100点伤害 
/// </summary>
public class Skill219 : BaseSkill
{
	// 反击的伤害
	int damage;
	
	public Skill219(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
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
		card.attacker.OnHurt(damage);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));

		List<BaseFighter> targetList = card.owner.GetTargetByType(this, TargetType);
		if (targetList != null || targetList.Count == 0)
			return;

		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(targetList)));
		foreach (CardFighter target in targetList)
		{
			if (!target.IsDead)
				target.OnHurt(damage);
		}
	}
}
