using UnityEngine;
using System.Collections;
using System.Collections.Generic;

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
	public void DoAttack()
	{
		DispatchEvent(BattleEventType.ON_PRE_ATTACK);

		if (attackSkill != null)
			attackSkill.DoSkill();

		DispatchEvent(BattleEventType.ON_AFTER_ATTACK);
	}

	/// <summary>
	/// 战斗Action
	/// </summary>
	public override List<BaseAction> Actions
	{
		get { return owner.Actions; }
	}
	
	/// <summary>
	/// 当卡牌受到伤害
	/// </summary>
	public override int OnAttackHurt(BaseFighter attacker, int damage)
	{
		return base.OnAttackHurt(attacker, damage);
	}

	/// <summary>
	/// 卡牌死亡
	/// </summary>
	public override void DoDead()
	{
		owner.CardToCemetery(this);
	}

	/// <summary>
	/// 卡牌回到牌堆
	/// </summary>
	public void DoBack()
	{
		owner.CardToCardArea(this);
	}

	/// <summary>
	/// 卡牌复活
	/// </summary>
	public void DoRevive()
	{
		owner.CardRevive(this);
	}
}
