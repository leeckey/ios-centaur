using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 战斗管理类
/// </summary>
public class BattleRoom
{
	// 战斗回合数
	public int round = 0;

	// 战斗对象
	public PlayerFighter fighter0;
	public PlayerFighter fighter1;

	// 是否暂停中
	public bool pause = false;

	// 战斗结果
	public int result = 0;

	// 所有战斗步骤
	public List<BaseAction> actions;

	public BattleRoom()
	{
		actions = new List<BaseAction>();
	}

	public void SetFighters(PlayerFighter fighter0, PlayerFighter fighter1)
	{
		this.fighter0 = fighter0;
		this.fighter1 = fighter1;

		fighter0.Rival = fighter1;
		fighter1.Rival = fighter0;

		fighter0.Room = this;
		fighter1.Room = this;
	}

	/// <summary>
	/// 开始战斗,第一个玩家先手
	/// </summary>
	public void StartFight()
	{
		fighter0.InitFight();
		fighter1.InitFight();

		// 循环直到一方死亡
		while ((result = CheckWin()) == 0 && !pause && round <= 100)
		{
			round ++;

			// 记录回合开始
			actions.Add(RoundStartAction.GetAction(round));

			if (round % 2 == 1)
				fighter0.Action();
			else
				fighter1.Action();

			// 记录回合结束
			actions.Add(RoundEndAction.GetAction(round));

			fighter0.RoundEnd();
			fighter1.RoundEnd();
		}

		foreach (BaseAction action in actions)
		{
			Debug.Log(action.ToString());
		}

		if (result == 1)
			Debug.Log(string.Format("{0}死亡,{1}胜利", fighter1.ID, fighter0.ID));
		else
			Debug.Log(string.Format("{0}死亡,{1}胜利", fighter0.ID, fighter1.ID));
	}

	/// <summary>
	/// 检测是否结束
	/// </summary>
	int CheckWin()
	{
		if (fighter1.IsDead)
			return 1;
		else if (fighter0.IsDead)
			return -1;
		else
			return 0;
	}
}
