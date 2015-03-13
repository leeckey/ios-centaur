using UnityEngine;
using System.Collections;

/// <summary>
/// 将正面敌方卡牌送回牌堆
/// </summary>
public class Skill109 : BaseSkill
{
	public Skill109(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	// 回到牌堆
	protected override void _DoSkill(BaseFighter target)
	{
		CardFighter tempCard = target as CardFighter;

		if (tempCard != null)
			tempCard.DoBack();
	}
}
