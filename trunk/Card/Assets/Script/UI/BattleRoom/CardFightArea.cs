using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 卡牌战斗区域
/// </summary>
public class CardFightArea : CardBaseArea
{
	/// <summary>
	/// 增加一个卡牌到区域内,带动画表现
	/// </summary>
	public override float AddCard(CardFighter card, Vector3 pos)
	{
		cards.Add(card);
		
		// 生成一张卡牌从pos位置移动过来
		
		return 0.5f;
	}
	
	/// <summary>
	/// 增加一个卡牌
	/// </summary>
	public override float AddCard(CardFighter card)
	{
		// 显示这张卡牌到等待区域
		
		return base.AddCard(card);
	}
	
	/// <summary>
	/// 移除区域中一个卡牌
	/// </summary>
	public override float RemoveCard(CardFighter card)
	{
		// 删除显示对象
		
		return base.RemoveCard(card);
	}
	
	/// <summary>
	/// 移除区域中一个卡牌,带动画表现
	/// </summary>
	public override float RemoveCard(CardFighter card, Vector3 pos)
	{
		cards.Remove(card);
		
		// 显示对象移动到pos位置
		
		return 0.5f;
	}
}
