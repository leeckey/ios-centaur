using UnityEngine;
using System.Collections;

/// <summary>
/// 抽取卡牌
/// </summary>
public class DrawCardAction : BaseAction
{
	DrawCardAction(int ownerID, int cardID)
	{
		type = ActionType.DrawCard;
		sourceID = ownerID;
		targetID = cardID;
	}

	public override string ToString()
	{
		return string.Format("卡牌{0}进入等待区", targetID);
	}

	public static DrawCardAction GetAction(int ownerID, int cardID)
	{
		return new DrawCardAction(ownerID, cardID);
	}
}
