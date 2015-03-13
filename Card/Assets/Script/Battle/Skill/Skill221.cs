using UnityEngine;
using System.Collections;

/// <summary>
/// 疾病技能:当攻击并对目标造成伤害时,对方丧失10点攻击力和生命值 
/// </summary>
public class Skill221 : BaseSkill
{
	// 减少攻击力数值
	int deAtt;
	
	public Skill221(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		deAtt = skillData.param1 * skillLevel;
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

	void OnAttackSucc(FighterEvent e)
	{
		if (card.lastAttackValue > 0)
		{
			card.target.DeductAttack(deAtt);
			card.target.DeductHp(deAtt);
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
