using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 战斗区域基类
/// </summary>
public class CardBaseArea : MonoBehaviour
{
	protected List<CardFighter> cards;
	
	// 是否存在某个卡牌
	public bool ContainsCard(CardFighter card)
	{
		return cards.Contains(card);
	}

	/// <summary>
	/// 增加一个卡牌
	/// </summary>
	public virtual float AddCard(CardFighter card)
	{
		cards.Add(card);
		return 0;
	}

	/// <summary>
	/// 增加一个卡牌到区域内,带动画表现
	/// </summary>
	public virtual float AddCard(CardFighter card, Vector3 pos)
	{
		return AddCard(card);
	}

	/// <summary>
	/// 移除区域中一个卡牌
	/// </summary>
	public virtual float RemoveCard(CardFighter card)
	{
		cards.Remove(card);
		return 0;
	}

	/// <summary>
	/// 移除区域中一个卡牌,带动画表现
	/// </summary>
	public virtual float RemoveCard(CardFighter card, Vector3 pos)
	{
		return RemoveCard(card);
	}

	/// <summary>
	/// 获得某张卡牌的位置
	/// </summary>
	public virtual Vector3 GetPos(CardFighter card = null)
	{
		return gameObject.transform.position;
	}	
}
