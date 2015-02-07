using UnityEngine;
using System.Collections;

/// <summary>
/// 出牌
/// </summary>
public class PlayCardAction : BaseAction
{
	PlayCardAction(int ownerID, int cardID)
	{
		type = ActionType.PlayCard;
		sourceID = ownerID;
		targetID = cardID;
	}

	public override string ToString()
	{
		return string.Format("卡牌{0}进入战斗区", targetID);
	}

	public static PlayCardAction GetAction(int ownerID, int cardID)
	{
		return new PlayCardAction(ownerID, cardID);
	}
}
