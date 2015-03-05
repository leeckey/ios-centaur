using UnityEngine;
using System.Collections;

/// <summary>
/// 冰弹:使一张或者多张卡牌受到100点伤害,30%概率下一回合无法行动 
/// </summary>
public class Skill101 : BaseSkill
{
	public Skill101(Card card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void _DoSkill(BaseFighter target)
	{
		if (card.Attack <= 0)
			return;
		
		// 卡牌存在,攻击卡牌
		target.OnAttackHurt(card, card.Attack);
	}
}
