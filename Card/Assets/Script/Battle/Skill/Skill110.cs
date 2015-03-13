using UnityEngine;
using System.Collections;

/// <summary>
/// 复活:将我方1张无复活技能的卡牌从墓地召唤上场
/// </summary>
public class Skill110 : BaseSkill
{
	public Skill110(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	// 回到牌堆
	protected override void _DoSkill(BaseFighter target)
	{
		CardFighter tempCard = target as CardFighter;
		
		if (tempCard != null)
			tempCard.DoRevive();
	}
}
