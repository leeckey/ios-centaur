using UnityEngine;
using System.Collections;

/// <summary>
/// 立即杀死敌方一张卡片
/// </summary>
public class Skill108 : BaseSkill
{
	public Skill108(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	
	protected override void _DoSkill(BaseFighter target)
	{
		target.DoDead();
	}
}
