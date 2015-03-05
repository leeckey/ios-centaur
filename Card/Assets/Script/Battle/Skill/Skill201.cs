using UnityEngine;
using System.Collections;

/// <summary>
/// 暴击:攻击时有50几率提高100%攻击力 
/// </summary>
public class Skill201 : BaseSkill
{
	// 暴击概率
	float rate;

	// 提升攻击力的概率
	float attackUpRate;

	// 提升的攻击力
	int attackUp;

	public Skill201(Card card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);

		rate = skillData.param1 / 100f;
		attackUpRate = skillData.param2 * skillLevel;
		attackUp = 0;
	}
	
	public override void RegisterCard(Card card)
	{
		base.RegisterCard(card);

		card.AddEventListener(BattleEventType.ON_PRE_ATTACK, OnPreAttack);

		card.AddEventListener(BattleEventType.ON_PRE_ATTACK, OnAfterAttack);
	}
	
	public override void RemoveCard(Card card)
	{
		base.RemoveCard(card);

		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnPreAttack);
		
		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnAfterAttack);
	}

	void OnPreAttack(FighterEvent e)
	{

	}

	void OnAfterAttack(FighterEvent e)
	{

	}
}
