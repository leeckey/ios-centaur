using UnityEngine;
using System.Collections;

/// <summary>
/// 回合结束
/// </summary>
public class RoundEndAction : BaseAction
{
	// 回合数
	int round;

	RoundEndAction(int round)
	{
		type = ActionType.RoundEnd;
		this.round = round;
	}

	public override string ToString()
	{
		return string.Format("回合{0}结束", round);
	}

	public static RoundEndAction GetAction(int round)
	{
		return new RoundEndAction(round);
	}
}
