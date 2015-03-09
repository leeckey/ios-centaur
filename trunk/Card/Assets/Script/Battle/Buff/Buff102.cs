using UnityEngine;
using System.Collections;

/// <summary>
/// 毒雾：行动结束后受到50点伤害 
/// </summary>
public class Buff102 : BaseBuff
{
	// 伤害
	int damage;

	public Buff102(BuffData data, int level) : base(data, level)
	{
		damage = data.param1 * level;
	}
	
	protected override void OnRoundEnd(FighterEvent e)
	{
		if (!card.IsDead)
			card.OnHurt(damage);

		base.OnRoundEnd(e);
	}
}
