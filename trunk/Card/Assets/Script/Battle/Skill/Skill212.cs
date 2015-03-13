using UnityEngine;
using System.Collections;

/// <summary>
/// 嗜血：每次攻击对方造成伤害时，提升30点攻击力 
/// </summary>
public class Skill212 : BaseSkill
{
	// 伤害比率
	int addAtt;
	
	public Skill212(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		addAtt = skillData.param1 * skillLevel;
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
			card.AddAttack(addAtt);
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
