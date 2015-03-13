using UnityEngine;
using System.Collections;

/// <summary>
/// 冰冻buff,不能攻击和释放技能
/// </summary>
public class Buff100 : BaseBuff
{
	public Buff100(BuffData data, int level) : base(data, level)
	{

	}

	public override void AddBuff(CardFighter card)
	{
		base.AddBuff(card);

		card.isActive++;
		BuffAddAction.GetAction(card.ID, ID);
	}

	public override void RemoveBuff()
	{
		card.isActive--;
		BuffAddAction.GetAction(card.ID, ID);

		base.RemoveBuff ();
	}
}
