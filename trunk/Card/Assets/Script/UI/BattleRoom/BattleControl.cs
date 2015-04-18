using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BattleControl : MonoBehaviour
{
	// 战斗房间数据
	BattleRoom battleRoom;

	// 具体操作
	List<BaseAction> actions;

	// 战斗处理类
	HandleFactory handleFactory;

	// 战斗UI
	BattleRoomUI roomUI;

	void Awake()
	{
		roomUI = gameObject.GetComponent<BattleRoomUI>();
	}

	/// <summary>
	/// 开始战斗
	/// </summary>
	public void StartFight(BattleRoom data)
	{
		this.battleRoom = data;

		InitBattleRoom();

		MoveNext();
	}

	/// <summary>
	/// 初始化战斗数据
	/// </summary>
	public void InitBattleRoom()
	{
		handleFactory = gameObject.AddComponent<HandleFactory>();
		
		actions = new List<BaseAction>(battleRoom.actions);
	}
	
	// 处理下一个Action
	public void MoveNext()
	{
		if (actions.Count > 0)
		{
			BaseAction action = actions[0];
			actions.RemoveAt(0);
			
			BaseHandler handle = handleFactory.GetHandle(action.type);
			handle.Handle(action);
		}
		else
		{
			// 战斗结束
		}
	}
}
