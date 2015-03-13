using UnityEngine;
using System.Collections;

/// <summary>
/// 削弱：当对对方造成物理伤害时，减少对方20点攻击力 
/// </summary>
public class Skill213 : BaseSkill
{
	// 伤害比率
	int deAtt;
	
	public Skill213(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
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
	
	// 攻击成功后提示攻击力
	void OnAttackSucc(FighterEvent e)
	{
		if (card.lastAttackValue > 0)
		{
			card.target.DeductAttack(deAtt);
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
