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

	protected bool isDead;

	public BaseSkill attackerSkill;

	// 是否免疫技能
	public bool canDoSkill = true;
	
	// 是否可被治疗
	public int canBeCure = 0;

	// 初始化
	protected virtual void Reset()
	{

	}

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
	/// 增加最大血量
	/// </summary>
	public virtual void AddMaxHp(int num)
	{
		maxHp += num;

		hp += num;

		Actions.Add(MaxHpChangeAction.GetAction(this.ID, num));
	}

	/// <summary>
	/// 减少最大血量
	/// </summary>
	public virtual void DeductMaxHp(int num)
	{
		maxHp -= num;
		if (hp > maxHp)
			hp = maxHp;

		Actions.Add(MaxHpChangeAction.GetAction(this.ID, -num));
	}

	/// <summary>
	/// 加血,最大不超过MaxHP
	/// </summary>
	public virtual int AddHp(int num)
	{
		if (canBeCure > 0)
			return 0;

		int temp = this.hp;
		this.hp = Mathf.Min(maxHp, this.hp + num);
		temp = this.hp - temp;

		Actions.Add(CureNotifyAction.GetAction(this.ID, temp));

		return temp;
	}

	/// <summary>
	/// 扣HP,最少为0
	/// </summary>
	public virtual int DeductHp(int num, bool checkDead = false)
	{
		if (IsDead)
			return 0;

		int temp = this.hp;

		this.hp = Mathf.Max(0, this.hp - num);
		temp -= hp;

		Actions.Add(DamageNotifyAction.GetAction(this.ID, temp));

		if (checkDead)
			CheckDead();

		return temp;
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
		if (isDead)
			return;

		isDead = true;
	}

	/// <summary>
	/// 增加攻击力不设上线
	/// </summary>
	public virtual int AddAttack(int num)
	{
		this.attack += num;
		
		AttackChangeAction.GetAction(this.ID, num);

		return num;
	}

	/// <summary>
	/// 减少攻击力最低为0
	/// </summary>
	public virtual int DeductAttack(int num)
	{
		int temp = this.attack;
		this.attack = Mathf.Max(0, this.attack - num);
		temp -= this.attack;

		AttackChangeAction.GetAction(this.ID, temp);
		return temp;
	}

	/// <summary>
	/// 受到普通攻击
	/// </summary>
	public virtual int OnAttackHurt(BaseFighter attacker, int damage)
	{
		if (IsDead)
			return 0;
		
		DeductHp(damage, true);

		return damage;
	}

	/// <summary>
	/// 受到技能攻击
	/// </summary>
	public virtual int OnSkillHurt(BaseSkill skill, int damage)
	{
		if (IsDead)
			return 0;
		
		DeductHp(damage, true);

		return damage;
	}

	/// <summary>
	/// 直接收到伤害
	/// </summary>
	public virtual int OnHurt(int damage)
	{
		return DeductHp(damage, true);
	}

	/// <summary>
	/// 是否可以被魔法攻击
	/// </summary>
	public virtual bool CanDoSkill()
	{
		return canDoSkill;
	}

}
