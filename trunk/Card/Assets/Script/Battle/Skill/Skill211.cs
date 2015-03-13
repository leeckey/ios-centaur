using UnityEngine;
using System.Collections;

/// <summary>
/// 狂热：被攻击时提升30点攻击力
/// </summary>
public class Skill211 : BaseSkill
{
	// 提升的攻击力
	int addAtt;
	
	public Skill211(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
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
		
		card.AddEventListener(BattleEventType.ON_AFTER_ATTACK_HURT, OnAfterAttackHurt);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_AFTER_ATTACK_HURT, OnAfterAttackHurt);
		
		base.RemoveCard(card);
	}
	
	// 提升30点攻击力
	void OnAfterAttackHurt(FighterEvent e)
	{
		card.AddAttack(addAtt);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
	}
}
