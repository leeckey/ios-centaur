using UnityEngine;
using System.Collections;

/// <summary>
/// 收到技能攻击时,最多收到100点伤害
/// </summary>
public class Skill206 : BaseSkill
{
	// 最高伤害
	int maxHurt;
	
	public Skill206(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig(skillData);
		
		maxHurt = skillData.param1 * skillLevel;
	}
	
	public override void RegisterCard(CardFighter card)
	{
		base.RegisterCard(card);
		
		card.AddEventListener(BattleEventType.ON_PRE_SKILL_HURT, OnPreSkillHurt);
	}
	
	public override void RemoveCard(CardFighter card)
	{
		card.RemoveEventListener(BattleEventType.ON_PRE_ATTACK, OnPreSkillHurt);
		
		base.RemoveCard(card);
	}
	
	// 最高受到伤害
	void OnPreSkillHurt(FighterEvent e)
	{
		if (card.attackSkill.SkillType != (int)SkillMagicEnum.SKILL_MAAGIC_TYPE)
			return;

		card.lastHurtValue = Mathf.Min(maxHurt, card.lastHurtValue);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, GetTargetID(card)));
	}
}
