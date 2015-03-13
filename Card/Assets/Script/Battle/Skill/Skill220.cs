using UnityEngine;
using System.Collections;

/// <summary>
/// 燃烧:受到物理攻击时,使对方燃烧,在其每次行动结束后丢失25点生命值 
/// </summary>
public class Skill220 : BaseSkill
{
	public Skill220(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);
		
		card.AddEventListener(BattleEventType.ON_AFTER_ATTACK_HURT, OnAttackSucc);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_AFTER_ATTACK_HURT, OnAttackSucc);
		
		base.RemoveCard(card);
	}
	
	void OnAttackSucc(FighterEvent e)
	{
		BaseBuff buff = BuffFactory.GetBuffByID(BuffID, skillLevel);
		card.attacker.AddBuff(buff);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
	}
}
