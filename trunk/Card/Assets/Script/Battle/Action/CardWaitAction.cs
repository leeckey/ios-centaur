using UnityEngine;
using System.Collections;

/// <summary>
/// 进入等待区
/// </summary>
public class CardWaitAction : BaseAction
{
	CardWaitAction(int ownerID, int cardID)
	{
		type = ActionType.CardWait;
		sourceID = ownerID;
		targetID = cardID;
	}
	
	public override string ToString()
	{
		return string.Format("卡牌{0}进入等待区", targetID);
	}
	
	public static CardWaitAction GetAction(int ownerID, int cardID)
	{
		return new CardWaitAction(ownerID, cardID);
	}
}
