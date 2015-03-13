using UnityEngine;
using System.Collections;

/// <summary>
/// 暴击:攻击时有50几率提高100%攻击力 
/// </summary>
public class Skill201 : BaseSkill
{
	// 暴击概率
	int rate;

	// 提升攻击力的概率
	float attackUpRate;

	// 提升的攻击力
	int attackUp;

	public Skill201(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);

		rate = skillData.param1;
		attackUpRate = skillData.param2 * skillLevel;
		attackUp = 0;
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);

		card.AddEventListener(BattleEventType.ON_PRE_ATTACK, OnPreAttack);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnPreAttack);
		
		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnAfterAttack);

		base.RemoveCard(card);
	}

	// 攻击前判断暴击
	void OnPreAttack(FighterEvent e)
	{
		if (Random.Range(0, 100) < rate)
		{
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));

			// 触发暴击
			attackUp = (int)(card.Attack * attackUpRate / 100f);
			card.AddAttack(attackUp);
			card.AddEventListener(BattleEventType.ON_PRE_ATTACK, OnAfterAttack);
		}
	}

	// 攻击后还原攻击
	void OnAfterAttack(FighterEvent e)
	{
		if (attackUp > 0)
		{
			card.DeductAttack(attackUp);
			attackUp = 0;

			card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnAfterAttack);
		}
	}
}
