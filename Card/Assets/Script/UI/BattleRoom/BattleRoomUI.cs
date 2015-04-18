using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 战斗场景UI
/// </summary>
public class BattleRoomUI : MonoBehaviour
{
	// 回合计数
	public BattleRound battleRound;

	// 玩家1战斗区域
	public PlayerGround playerground0;

	// 玩家2战斗区域
	public PlayerGround playerground1;

	// 当前行动的玩家
	PlayerGround currPlayer;

	/// <summary>
	/// 卡牌回到牌堆
	/// </summary>
	public float CardBack(BaseAction action)
	{
		return currPlayer.CardBack(action);
	}

	/// <summary>
	/// 卡牌进入墓地
	/// </summary>
	public float CardDead(BaseAction action)
	{
		return currPlayer.CardDead(action);
	}

	/// <summary>
	/// 卡牌进入战斗
	/// </summary>
	public float CardFight(BaseAction action)
	{
		return currPlayer.CardFight(action);
	}

	/// <summary>
	/// 卡牌进入等待区
	/// </summary>
	public float CardWait(BaseAction action)
	{
		return currPlayer.CardWait(action);
	}
}
