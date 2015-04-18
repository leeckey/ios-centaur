using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 玩家显示区域
/// </summary>
public class PlayerGround : MonoBehaviour
{
	public UILabel nameLabel;
	
	public UITexture icon;
	
	public UISprite hpBar;

	// 初始区域
	public CardInitArea cardInitArea;

	// 等待区域
	public CardWaitArea cardWaitArea;

	// 战斗区域
	public CardFightArea cardFightArea;

	// 死亡区域
	public CardDeadArea cardDeadArea;

	// 所有卡牌
	List<CardFighter> allCards;

	/// <summary>
	/// 获得对应的卡牌
	/// </summary>
	public CardFighter GetCardByID(int id)
	{
		return allCards.Find(card => card.ID == id);
	}

	// 初始化数据
	public void InitPlayerInfo()
	{

	}

	/// <summary>
	/// 卡牌回到牌堆
	/// </summary>
	public float CardBack(BaseAction action)
	{
		CardBackAction cardBackAction = action as CardBackAction;

		CardFighter card = GetCardByID(cardBackAction.sourceID);

		// 等待中的卡牌回到牌堆
		if (cardWaitArea.ContainsCard(card))
			return cardWaitArea.RemoveCard(card, cardInitArea.GetPos());

		// 战斗中的卡牌回到牌堆
		if (cardFightArea.ContainsCard(card))
			return cardFightArea.RemoveCard(card, cardInitArea.GetPos());

		// 死亡的卡牌回到牌堆
		if (cardDeadArea.ContainsCard(card))
			return cardDeadArea.RemoveCard(card, cardInitArea.GetPos());

		cardInitArea.AddCard(card);
		return 0f;
	}
	
	/// <summary>
	/// 卡牌进入墓地
	/// </summary>
	public float CardDead(BaseAction action)
	{
		CardDeadAction cardDeadAction = action as CardDeadAction;

		CardFighter card = GetCardByID(cardDeadAction.sourceID);

		// 等待中的卡牌进入墓地
		if (cardWaitArea.ContainsCard(card))
			return cardWaitArea.RemoveCard(card, cardDeadArea.GetPos());
		
		// 战斗中的卡牌进入墓地
		if (cardFightArea.ContainsCard(card))
			return cardFightArea.RemoveCard(card, cardDeadArea.GetPos());

		cardDeadArea.AddCard(card);
		return 0f;
	}
	
	/// <summary>
	/// 卡牌进入战斗
	/// </summary>
	public float CardFight(BaseAction action)
	{
		CardFightAction cardFightAction = action as CardFightAction;

		CardFighter card = GetCardByID(cardFightAction.sourceID);

		// 等待中的卡牌进入战斗
		if (cardWaitArea.ContainsCard(card))
		{
			Vector3 pos = cardWaitArea.GetPos(card);
			cardWaitArea.RemoveCard(card);
			return cardFightArea.AddCard(card, pos);
		}
		
		// 死亡的卡牌进入战斗
		if (cardDeadArea.ContainsCard(card))
		{
			cardDeadArea.RemoveCard(card);
			return cardFightArea.AddCard(card, cardDeadArea.GetPos());
		}

		return 0f;
	}
	
	/// <summary>
	/// 卡牌进入等待区
	/// </summary>
	public float CardWait(BaseAction action)
	{
		CardWaitAction cardWaitAction = action as CardWaitAction;

		CardFighter card = GetCardByID(cardWaitAction.sourceID);

		// 牌堆的卡牌进入等待区
		if (cardInitArea.ContainsCard(card))
		{
			cardInitArea.RemoveCard(card);
			return cardWaitArea.AddCard(card, cardInitArea.GetPos());
		}
		
		// 战斗中的卡牌进入等待区
		if (cardFightArea.ContainsCard(card))
		{
			cardWaitArea.AddCard(card);
			return cardFightArea.RemoveCard(card, cardWaitArea.GetPos(card));
		}
		
		// 死亡的卡牌进入等待区
		if (cardDeadArea.ContainsCard(card))
		{
			cardDeadArea.RemoveCard(card);
			return cardWaitArea.AddCard(card, cardDeadArea.GetPos());
		}

		return 0f;
	}
}
