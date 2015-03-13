using UnityEngine;
using System.Collections;

/// <summary>
/// 卡牌进入战斗区
/// </summary>
public class CardFightAction : BaseAction
{
	CardFightAction(int ownerID, int cardID)
	{
		type = ActionType.CardFight;
		sourceID = ownerID;
		targetID = cardID;
	}
	
	public override string ToString()
	{
		return string.Format("卡牌{0}进入战斗区", targetID);
	}
	
	public static CardFightAction GetAction(int ownerID, int cardID)
	{
		return new CardFightAction(ownerID, cardID);
	}
}
