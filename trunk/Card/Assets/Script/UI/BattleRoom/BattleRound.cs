using UnityEngine;
using System.Collections;

/// <summary>
/// 战斗回合数显示
/// </summary>
public class BattleRound : MonoBehaviour
{
	/// <summary>
	/// 回合数增加
	/// </summary>
	public float AddRound(BaseAction action)
	{
		RoundStartAction roundStartAction = action as RoundStartAction;

		print("当前回合:" + roundStartAction.round);

		return 1f;
	}
}
