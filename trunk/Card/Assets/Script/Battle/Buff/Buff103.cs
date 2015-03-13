using UnityEngine;
using System.Collections;

/// <summary>
/// 裂伤Buff
/// </summary>
public class Buff103 : BaseBuff
{
	public Buff103(BuffData data, int level) : base(data, level)
	{
		
	}
	
	public override void AddBuff(CardFighter card)
	{
		base.AddBuff(card);
		
		card.canBeCure++;
		BuffAddAction.GetAction(card.ID, ID);
	}
	
	public override void RemoveBuff()
	{
		card.canBeCure--;
		BuffAddAction.GetAction(card.ID, ID);
		
		base.RemoveBuff ();
	}
}
