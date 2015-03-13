using UnityEngine;
using System.Collections;

/// <summary>
/// 受攻击时50%概率闪避
/// </summary>
public class Skill204 : BaseSkill
{
	// 闪避的概率
	int rate;
	
	public Skill204(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		rate = skillData.param1 + skillData.param2 * skillLevel;
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);
		
		card.AddEventListener(BattleEventType.ON_PRE_ATTACK_HURT, OnPreAttackHurt);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnPreAttackHurt);
		
		base.RemoveCard(card);
	}
	
	// 闪避攻击
	void OnPreAttackHurt(FighterEvent e)
	{
		if (Random.Range(0, 100) < rate)
		{
			card.lastHurtValue = 0;
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
