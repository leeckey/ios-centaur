using UnityEngine;
using System.Collections;

/// <summary>
/// 回到牌堆
/// </summary>
public class CardBackAction : BaseAction
{
	CardBackAction(int ownerID, int cardID)
	{
		type = ActionType.CardBack;
		sourceID = ownerID;
		targetID = cardID;
	}
	
	public override string ToString()
	{
		return string.Format("卡牌{0}回到牌堆", targetID);
	}
	
	public static CardBackAction GetAction(int ownerID, int cardID)
	{
		return new CardBackAction(ownerID, cardID);
	}
}
