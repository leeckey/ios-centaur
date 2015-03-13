using UnityEngine;
using System.Collections;

/// <summary>
/// 背刺:出场回合额外增加200点攻击力（类似降临系技能）
/// </summary>
public class Skill214 : BaseSkill
{
	// 提升攻击力的概率
	int attackUp;
	
	public Skill214(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);

		attackUp = skillData.param1 * skillLevel;
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);
		
		card.AddEventListener(BattleEventType.ON_CARD_PRESENT, OnPreAttack);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_CARD_PRESENT, OnPreAttack);
		
		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnAfterAttack);
		
		base.RemoveCard(card);
	}
	
	// 攻击前判断暴击
	void OnPreAttack(FighterEvent e)
	{
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		
		// 触发暴击
		card.AddAttack(attackUp);

		card.AddEventListener(BattleEventType.ON_PRE_ATTACK, OnAfterAttack);
	}
	
	// 攻击后还原攻击
	void OnAfterAttack(FighterEvent e)
	{
		card.DeductAttack(attackUp);
		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnAfterAttack);
	}
}
