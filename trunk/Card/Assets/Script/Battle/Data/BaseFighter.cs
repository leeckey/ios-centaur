using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 战斗对象基类
/// </summary>
public class BaseFighter : EventDispatcher<FighterEvent>
{
	public int ID;
	public int attack = 200;
	public int HP = 1000;
	public int level;



	public override void DispatchEvent(string type, object data = null)
	{
		base.DispatchEvent(type, this);
	}

	public bool IsDead
	{
		get { return HP <= 0; }
	}

	public virtual List<BaseAction> Actions
	{
		get { return new List<BaseAction>(); }
	}

	/// <summary>
	/// 加血
	/// </summary>
	public virtual void AddHp(int num)
	{
		this.HP += num;
	}

	/// <summary>
	/// 扣血
	/// </summary>
	public virtual void ReduceHp(int num)
	{
		this.HP -= num;

		Actions.Add(DamageNotifyAction.GetAction(this.ID, num));
	}

	public virtual void OnAttackHurt(BaseFighter attacker, int damage)
	{
		if (IsDead)
			return;
		
		ReduceHp(damage);
	}

}
