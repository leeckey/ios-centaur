using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 圣光:当攻击目标是地狱时,攻击力加成60%
/// </summary>
public class Skill223 : BaseSkill
{
	// 暴击种族
	int enemyType;
	
	// 提升攻击力的概率
	float attackUpRate;
	
	// 提升的攻击力
	int attackUp;
	
	public Skill223(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		enemyType = skillData.param1;
		attackUpRate = skillData.param2 * skillLevel + skillData.param3;
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
		List<BaseFighter> targets = card.owner.GetTargetByType(this, TargetType);
		if (targets == null || targets.Count == 0)
			return;

		CardFighter target = targets[0] as CardFighter;

		if (target != null && target.cardData.country == enemyType)
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
