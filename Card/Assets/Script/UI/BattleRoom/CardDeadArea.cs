using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 卡牌死亡区域
/// 移除或增加不需要变现,只显示最后增加进来的卡牌
/// </summary>
public class CardDeadArea : CardBaseArea
{
	/// <summary>
	/// 显示最新的死亡卡牌
	/// </summary>
	public override float AddCard(CardFighter card)
	{
		// 显示这张卡牌

		return base.AddCard(card);
	}

	public override float RemoveCard (CardFighter card)
	{
		// 显示最新的卡牌

		return base.RemoveCard (card);
	}
}
