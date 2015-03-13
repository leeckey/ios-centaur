using UnityEngine;
using System.Collections;

/// <summary>
/// Buff基类
/// </summary>
public class BaseBuff
{
	int id;
	int round;
	int superposition;
	int level;

	// 作用的对象
	protected CardFighter card;

	/// <summary>
	/// BuffID
	/// </summary>
	public int ID
	{
		get { return id; }
	}

	/// <summary>
	/// Buff持续回合数
	/// </summary>
	public int Round
	{
		get { return round; }
	}
	/// <summary>
	/// 是否可叠加
	/// </summary>
	public bool SuperPositon
	{
		get { return superposition == 0; }
	}

	/// <summary>
	/// Buff级别
	/// </summary>
	public int Level
	{
		get { return level; }
	}

	/// <summary>
	/// 构造函数
	/// </summary>
	public BaseBuff(BuffData data, int level)
	{

		id = data.id;
		round = data.round;
		this.level = level;
		superposition = data.superposition;

	}

	/// <summary>
	/// 增加Buff效果
	/// </summary>
	public virtual void AddBuff(CardFighter card)
	{
		this.card = card;

		card.AddEventListener(BattleEventType.ON_ROUND_END, OnRoundEnd);
	}

	/// <summary>
	/// 去掉Buff效果
	/// </summary>
	public virtual void RemoveBuff()
	{
		if (card == null)
			return;

		card.RemoveEventListener(BattleEventType.ON_ROUND_END, OnRoundEnd);

		card.RemoveBuff(this);
	}

	// 回合结束
	protected virtual void OnRoundEnd(FighterEvent e)
	{
		if (--round <= 0)
			RemoveBuff();
	}

	/// <summary>
	/// 吸收一个Buff的参数
	/// </summary>
	public virtual void CopyBuff(BaseBuff buff)
	{
		this.round = buff.Round;
		this.level = buff.Level;
	}
}
