using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 行动工厂
/// </summary>
public class HandleFactory : MonoBehaviour
{
	// 所有handle的索引
	Dictionary<ActionType, BaseHandler> handleMap;

	void Awake()
	{
		InitHandle();
	}

	void InitHandle()
	{
		handleMap = new Dictionary<ActionType, BaseHandler>();

		// 增加具体处理逻辑的Handle
		AddHandle<AttackChangeHandler>(ActionType.AttackChange);
		AddHandle<BuffAddHandler>(ActionType.BuffAdd);
		AddHandle<BuffRemoveHandler>(ActionType.BuffRemove);
		AddHandle<CardBackHandler>(ActionType.CardBack);
		AddHandle<CardDeadHandler>(ActionType.CardDead);
		AddHandle<CardFightHandler>(ActionType.CardFight);
		AddHandle<CardWaitHandler>(ActionType.CardWait);
		AddHandle<CureNotifyHandler>(ActionType.Cure);
		AddHandle<DamageNotifyHandler>(ActionType.Damage);
		AddHandle<MaxHpChangeHandler>(ActionType.MaxHpChange);
		AddHandle<RoundEndHandler>(ActionType.RoundEnd);
		AddHandle<RoundStartHandler>(ActionType.RoundStart);
		AddHandle<SkillEndHandler>(ActionType.SkillEnd);
		AddHandle<SkillStartHandler>(ActionType.SkillStart);
	}


	// 增加一个handdle
	void AddHandle<T>(ActionType actionType) where T : BaseHandler
	{
		handleMap.Add(actionType, gameObject.AddComponent<T>());
	}

	/// <summary>
	/// 获得一个具体行动
	/// </summary>
	public BaseHandler GetHandle(ActionType actionType)
	{
		if (handleMap.ContainsKey(actionType))
			return handleMap[actionType];

		return null;
	}
}
