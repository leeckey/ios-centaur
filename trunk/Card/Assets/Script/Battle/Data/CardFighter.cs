using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CardFighter : BaseFighter
{
	public int waitRound = 2;
	
	// 普通攻击技能
	public BaseSkill attackSkill;
	
	// 所有者
	public PlayerFighter owner;

	// 上次攻击造成的伤害
	public int lastAttackValue;

	// 上次收到的伤害
	public int lastHurtValue;

	// 攻击我的卡牌
	public CardFighter attacker;

	// 我攻击的卡牌
	public CardFighter target;
	
	// 是否可被摧毁或送还
	public bool canBeMove = true;

	// 是否可行动
	public int isActive = 0;

	// 是否可释放技能
	public int canUseSkill = 0;

	// 卡牌数据
	public CardTemplateData cardData;

	// 卡牌技能
	List<BaseSkill> skills;

	// 卡牌Buff
	List<BaseBuff> buffs;

	// 返回一个卡牌对象
	public static CardFighter NewCard(CardData cardData)
	{
		return new CardFighter(cardData.ID, cardData.cardTemplateID, cardData.cardLevel);
	}

	// 构造函数
	public CardFighter(int ID, int templateID, int level)
	{
		this.ID = ID;
		this.cardData = DataManager.GetInstance().cardData[templateID];
		this.Level = level;

		// 初始化技能
		InitSkill();

		// 重置数据
		Reset();
	}


	void InitSkill()
	{
		skills = new List<BaseSkill>();

		// 普攻技能
		attackSkill = SkillFactory.GetSkillByID(cardData.normolAttID, this);

		BaseSkill skill = null;
		if (cardData.skill1ID > 0)
		{
			skill = SkillFactory.GetSkillByID(cardData.skill1ID, this, cardData.GetSkillPara(1));
			skills.Add(skill);
		}

		if (cardData.skill2ID > 0)
		{
			skill = SkillFactory.GetSkillByID(cardData.skill2ID, this, cardData.GetSkillPara(2));
			skills.Add(skill);
		}

		if (cardData.skill3ID > 0)
		{
			skill = SkillFactory.GetSkillByID(cardData.skill3ID, this, cardData.GetSkillPara(2));
			skills.Add(skill);
		}
	}

	// 重置数据
	protected override void Reset()
	{
		// 最大血量和攻击力
		MaxHP = cardData.baseHP + cardData.growUpHP * Level;
		Attack = cardData.baseACK + cardData.growUpACK * Level;
		waitRound = cardData.maxWaitRound;

		buffs = new List<BaseBuff>();
		HP = MaxHP;
		lastAttackValue = 0;
		lastHurtValue = 0;
		attacker = null;
		target = null;
	}

	/// <summary>
	/// 开始攻击
	/// </summary>
	public void DoAttack()
	{
		if (isActive > 0)
			return;

		DispatchEvent(BattleEventType.ON_PRE_ATTACK);

		if (attackSkill != null)
			attackSkill.DoSkill();

		DispatchEvent(BattleEventType.ON_AFTER_ATTACK);
	}

	/// <summary>
	/// 卡牌开始行动
	/// </summary>
	public void Action()
	{
		// 回合开始
		RoundStart();

		if (IsDead)
			return;

		// 释放技能
		DoSkill();

		if (IsDead)
			return;

		// 普通攻击
		DoAttack();

		if (IsDead)
			return;

		// 回合结束
		RoundEnd();
	}

	// 回合开始
	void RoundStart()
	{
		DispatchEvent(BattleEventType.ON_ROUND_START);
	}

	// 回合结束
	public void RoundEnd()
	{
		DispatchEvent(BattleEventType.ON_ROUND_END);
	}

	/// <summary>
	/// 开始释放技能
	/// </summary>
	public void DoSkill()
	{
		if (isActive > 0 || canUseSkill > 0)
			return;

		foreach (BaseSkill skill in skills)
		{
			if (skill.SkillType == (int)SkillTypeEnum.SKILL_ACTIVE_TYPE)
				skill.DoSkill();
		}
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
		if (IsDead)
			return 0;

		this.attacker = attacker as CardFighter;
		this.attacker.target = this;

		lastHurtValue = damage;

		// 受伤前技能触发
		DispatchEvent(BattleEventType.ON_PRE_ATTACK_HURT);

		// 被动技能可能抵消了伤害
		if (lastHurtValue <= 0)
			return 0;

		// 开始扣血
		int hurt = DeductHp(lastHurtValue);
		if (hurt > 0)
		{
			// 攻击卡牌攻击成功消息
			this.attacker.lastAttackValue = hurt;
			this.attacker.DispatchEvent(BattleEventType.ON_ATTACK_SUCC);
		}

		// 被攻击结束消息
		DispatchEvent(BattleEventType.ON_AFTER_ATTACK_HURT);

		// 检查是否死亡
		CheckDead();
		
		return hurt;
	}

	/// <summary>
	/// 卡牌出场
	/// </summary>
	public void OnPresent()
	{
		Actions.Add(CardFightAction.GetAction(owner.ID, this.ID));
		DispatchEvent(BattleEventType.ON_CARD_PRESENT);
	}

	/// <summary>
	/// 受到技能攻击
	/// </summary>
	public override int OnSkillHurt(BaseSkill skill, int damage)
	{
		if (IsDead || !CanDoSkill())
			return 0;

		this.attacker = skill.card;
		attackerSkill = skill;

		lastHurtValue = damage;
		DispatchEvent(BattleEventType.ON_PRE_SKILL_HURT);

		if (lastHurtValue <= 0)
			return 0;

		// 开始扣血
		int hurt = DeductHp(lastHurtValue);
		if (hurt > 0)
		{
			// 攻击卡牌攻击成功消息
			this.attacker.lastAttackValue = hurt;
			this.attacker.DispatchEvent(BattleEventType.ON_SKILL_ATTACK_SUCC);
		}
		
		// 被攻击结束消息
		DispatchEvent(BattleEventType.ON_AFTER_ATTACK_HURT);
		
		// 检查是否死亡
		CheckDead();
		
		return hurt;
	}

	// 是否可作用技能
	public override bool CanDoSkill()
	{
		DispatchEvent(BattleEventType.ON_CHECK_IMMUNE);
		return canDoSkill;
	}

	public bool CanBeMove()
	{
		DispatchEvent(BattleEventType.ON_CHECK_MOVE);
		return canBeMove;
	}

	/// <summary>
	/// 卡牌死亡
	/// </summary>
	public override void DoDead()
	{
		if (isDead)
			return;
		
		isDead = true;
		Actions.Add(CardDeadAction.GetAction(owner.ID, this.ID));
		owner.CardToCemetery(this);
	}

	/// <summary>
	/// 卡牌回到牌堆
	/// </summary>
	public void DoBack()
	{
		Actions.Add(CardBackAction.GetAction(owner.ID, this.ID));
		owner.CardToCardArea(this);
	}

	/// <summary>
	/// 卡牌复活
	/// </summary>
	public void DoRevive()
	{
		owner.CardRevive(this);
	}

	/// <summary>
	/// 卡牌进入等待区
	/// </summary>
	public void DoWait()
	{
		Actions.Add(CardWaitAction.GetAction(owner.ID, this.ID));
		owner.CardToWait(this);
	}

	/// <summary>
	/// 添加一个buff
	/// </summary>
	public void AddBuff(BaseBuff buff)
	{
		if (!buff.SuperPositon && HasBuff(buff.ID))
			return;

		buff.AddBuff(this);
		buffs.Add(buff);
	}

	/// <summary>
	/// 移除一个Buff
	/// </summary>
	public void RemoveBuff(BaseBuff buff)
	{
		buffs.Remove(buff);
	}

	/// <summary>
	/// 是否有同样的Buff
	/// </summary>
	public bool HasBuff(int id)
	{
		foreach (BaseBuff buff in buffs)
		{
			if (buff.ID == id && buff.Round > 0)
				return true;
		}

		return false;
	}
}
