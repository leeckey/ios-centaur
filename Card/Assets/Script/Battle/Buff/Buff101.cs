using UnityEngine;
using System.Collections;

/// <summary>
/// 闪电buff,不能释放技能
/// </summary>
public class Buff101 : BaseBuff
{
	public Buff101(BuffData data, int level) : base(data, level)
	{
		
	}
	
	public override void AddBuff(CardFighter card)
	{
		base.AddBuff(card);
		
		card.canUseSkill++;
		BuffAddAction.GetAction(card.ID, ID);
	}
	
	public override void RemoveBuff()
	{
		card.canUseSkill--;
		BuffAddAction.GetAction(card.ID, ID);
		
		base.RemoveBuff ();
	}
}
