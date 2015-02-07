using UnityEngine;
using System.Collections;

public class Card : BaseFighter
{
	public int waitRound = 2;
	
	// 普通攻击技能
	public BaseSkill attackSkill;
	
	// 所有者
	public Player owner;

	/// <summary>
	/// 开始攻击
	/// </summary>
	public void Attack()
	{
		if (attackSkill != null)
			attackSkill.DoSkill();
	}
	
	/// <summary>
	/// 当卡牌受到伤害
	/// </summary>
	public override void OnAttackHurt(BaseFighter attacker, int damage)
	{
		base.OnAttackHurt(attacker, damage);
	}

	public override void ReduceHp(int num)
	{
		base.ReduceHp(num);
		
		CheckDead();
	}

	void CheckDead()
	{
		if (HP <= 0)
			owner.CardTocemetery(this);
	}
}
