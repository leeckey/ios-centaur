using UnityEngine;
using System.Collections;

/// <summary>
/// 裂伤技能:当攻击并对敌方造成物理伤害时施放,使对方无法回春和被治疗 
/// </summary>
public class Skill222 : BaseSkill
{
	public Skill222(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
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
	
	// 攻击成功后提示攻击力
	void OnAttackSucc(FighterEvent e)
	{
		if (card.lastAttackValue > 0)
		{
			BaseBuff buff = BuffFactory.GetBuffByID(BuffID, skillLevel);
			card.target.AddBuff(buff);
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
