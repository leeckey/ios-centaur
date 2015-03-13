using UnityEngine;
using System.Collections;

/// <summary>
/// 吸血:攻击造成物理伤害时，恢复伤害50%的生命值
/// </summary>
public class Skill208 : BaseSkill
{
	// 吸血比率
	int rate;
	
	public Skill208(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		rate = skillData.param1 * skillLevel;
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);
		
		card.AddEventListener(BattleEventType.ON_ATTACK_SUCC, OnAttackSucc);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_ATTACK_SUCC, OnAttackSucc);
		
		base.RemoveCard(card);
	}
	
	// 伤害后吸血
	void OnAttackSucc(FighterEvent e)
	{
		if (card.lastAttackValue > 0)
		{
			card.AddHp((int)(card.lastAttackValue * rate / 100f));
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
