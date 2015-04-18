using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 行动基类
/// </summary>
public class BaseHandler : MonoBehaviour
{
	// 战斗UI
	protected BattleRoomUI roomUI;

	// 战斗控制类
	protected BattleControl battleControl;

	// 当前处理的行为
	protected BaseAction action;

	public delegate float HandlerDelegate(BaseAction action);
	public List<HandlerDelegate> handleList;


	void Awake()
	{
		roomUI = gameObject.GetComponent<BattleRoomUI>();

		battleControl = gameObject.GetComponent<BattleControl>();
	}

	protected virtual void InitHandle()
	{
		handleList = new List<HandlerDelegate>();
	}

	// 处理动画
	public virtual void Handle(BaseAction action)
	{
		this.action = action;

		InitHandle();

		StartCoroutine(_Handle());
	}

	// 处理所有动作
	protected IEnumerator _Handle()
	{
		float delay = 0f;
		while (handleList.Count > 0)
		{
			HandlerDelegate handle = handleList[0];
			handleList.RemoveAt(0);
			delay = handle(action);

			yield return new WaitForSeconds(delay);
		}

		battleControl.MoveNext();
	}
}
