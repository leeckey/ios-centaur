using UnityEngine;
using System.Collections;

/// <summary>
/// 回合开始处理
/// </summary>
public class RoundStartHandler : BaseHandler
{
	/// <summary>
	/// 增加回合数
	/// </summary>
	protected override void InitHandle()
	{
		base.InitHandle();

		handleList.Add(roomUI.battleRound.AddRound);
	}
}
