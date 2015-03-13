using UnityEngine;
using System.Collections;

/// <summary>
/// 穿刺:对敌方卡牌造成伤害时，敌方英雄同时受到100%的伤害
/// </summary>
public class Skill209 : BaseSkill
{
	// 伤害比率
	int rate;
	
	public Skill209(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		rate = skillData.param1 * skillLevel;
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
	
	// 敌方英雄同时受到100%的伤害
	void OnAttackSucc(FighterEvent e)
	{
		if (card.lastAttackValue > 0)
		{
			card.owner.Rival.DeductHp((int)(card.lastAttackValue * rate / 100f));
			card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
		}
	}
}
