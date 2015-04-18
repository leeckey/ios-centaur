using UnityEngine;
using System.Collections;

/// <summary>
/// 回合开始
/// </summary>
public class RoundStartAction : BaseAction
{
	// 回合数
	public int round;

	RoundStartAction(int round)
	{
		type = ActionType.RoundStart;
		this.round = round;
	}

	public override string ToString()
	{
		return string.Format("回合{0}开始", round);
	}

	public static RoundStartAction GetAction(int round)
	{
		return new RoundStartAction(round);
	}
}
