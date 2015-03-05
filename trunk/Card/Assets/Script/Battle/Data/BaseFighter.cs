using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 战斗对象基类
/// </summary>
public class BaseFighter : EventDispatcher<FighterEvent>
{
	private int id;
	private int attack = 200;
	private int maxHp = 1000;
	private int hp = 1000;
	private int level;

	// 战斗者ID
	public int ID
	{
		get { return id; }
		set { id = value; }
	}

	// 攻击力
	public int Attack
	{
		get { return attack; }
		set { attack = value; }
	}

	// 当前HP
	public int HP
	{
		get { return hp; }
		set { hp = value; }
	}

	// 最大HP
	public int MaxHP
	{
		get { return maxHp; }
		set { maxHp = value; }
	}

	// 级别
	public int Level
	{
		get { return level; }
		set { level = value; }
	}

	public override void DispatchEvent(string type, object data = null)
	{
		base.DispatchEvent(type, this);
	}

	public bool IsDead
	{
		get { return hp <= 0; }
	}

	public virtual List<BaseAction> Actions
	{
		get { return new List<BaseAction>(); }
	}

	/// <summary>
	/// 加血,最大不超过MaxHP
	/// </summary>
	public virtual int AddHp(int num)
	{
		this.hp += num;

		return num;
	}

	/// <summary>
	/// 扣HP,最少为0
	/// </summary>
	public virtual int ReduceHp(int num)
	{
		this.hp -= num;

		Actions.Add(DamageNotifyAction.GetAction(this.id, num));


		CheckDead();

		return num;
	}

	// 死亡检查
	protected void CheckDead()
	{
		if (hp <= 0)
			DoDead();
	}

	/// <summary>
	/// 死亡处理
	/// </summary>
	public virtual void DoDead()
	{

	}

	/// <summary>
	/// 增加攻击力不设上线
	/// </summary>
	public virtual int AddAttack(int num)
	{
		this.attack += num;

		return num;
	}

	/// <summary>
	/// 减少攻击力最低为0
	/// </summary>
	public virtual int DeduceAttack(int num)
	{
		this.attack -= num;
		
		return num;
	}

	/// <summary>
	/// 受到普通攻击
	/// </summary>
	public virtual int OnAttackHurt(BaseFighter attacker, int damage)
	{
		if (IsDead)
			return 0;
		
		ReduceHp(damage);

		return damage;
	}

	/// <summary>
	/// 受到技能攻击
	/// </summary>
	public virtual int OnSkillHurt(BaseFighter attacker, int damage)
	{
		if (IsDead)
			return 0;
		
		ReduceHp(damage);

		return damage;
	}

	/// <summary>
	/// 是否可以被魔法攻击
	/// </summary>
	public virtual bool CanDoSkill()
	{
		return true;
	}

}
