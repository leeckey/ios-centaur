using UnityEngine;
using System.Collections;

/// <summary>
/// 卡牌进入墓地
/// </summary>
public class CardDeadAction : BaseAction
{
	CardDeadAction(int ownerID, int cardID)
	{
		type = ActionType.CardDead;
		sourceID = ownerID;
		targetID = cardID;
	}
	
	public override string ToString()
	{
		return string.Format("卡牌{0}进入墓地", targetID);
	}
	
	public static CardDeadAction GetAction(int ownerID, int cardID)
	{
		return new CardDeadAction(ownerID, cardID);
	}
}
