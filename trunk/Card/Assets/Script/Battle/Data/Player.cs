using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 战斗玩家数据
/// </summary>
public class Player : BaseFighter
{
	// 基础属性
	public string name;
	public int maxHp;
	
	// 是否自动
	public bool auto = true;

	// 所有卡牌
	public List<Card> allCard;

	// 初始卡组
	List<Card> initialCard;

	// 等待卡组
	List<Card> waitCard;

	// 战斗卡组
	List<Card> fightCard;

	// 墓地卡组
	List<Card> cemeteryCard;

	// 玩家状态
	FigtherStatus status;

	/// <summary>
	/// 战斗状态
	/// </summary>
	enum FigtherStatus
	{
		waiting,
		drawCard,
		playCard,
		attack,
		actionEnd
	}

	public Player()
	{
		allCard = new List<Card>();
		initialCard = new List<Card>();
		waitCard = new List<Card>();
		fightCard = new List<Card>();
		cemeteryCard = new List<Card>();
	}

	/// <summary>
	/// 战斗对手
	/// </summary>
	Player rival;
	public Player Rival
	{
		get { return rival; }
		set { rival = value; }
	}

	/// <summary>
	/// 战斗房间
	/// </summary>
	BattleRoom room;
	public BattleRoom Room
	{
		get { return room; }
		set { room = value; }
	}

	/// <summary>
	/// 战斗Action
	/// </summary>
	public override List<BaseAction> Actions
	{
		get { return room.actions; }
	}

	public void InitFight()
	{
		allCard.ForEach(i => initialCard.Add(i));
	}
	
	/// <summary>
	/// 开始行动
	/// </summary>
	public void Action()
	{
		// 开始战斗
		if (status == FigtherStatus.waiting)
			ActionStart();

		// 抽牌
		if (status == FigtherStatus.drawCard)
			DrawCard();

		// 出牌
		if (status == FigtherStatus.playCard)
		{
			// 不是自动战斗退出
			if (!auto)
			{
				room.pause = true;
				return;
			}
			PlayCard();
		}

		if (IsDead || rival.IsDead)
			return;

		// 开始攻击
		if (status == FigtherStatus.attack)
			FightCard();

		if (IsDead || rival.IsDead)
			return;

		// 回合结束
		if (status == FigtherStatus.actionEnd)
			ActionEnd();
	}

	void ActionStart()
	{
		status = FigtherStatus.drawCard;
	}

	// 抽牌
	void DrawCard()
	{
		status = FigtherStatus.playCard;

		// 随机抽取卡牌
		if (initialCard.Count == 0)
			return;

		Card card = initialCard[Random.Range(0, initialCard.Count)];

		initialCard.Remove(card);

		waitCard.Add(card);

		// 记录ID
		Actions.Add(DrawCardAction.GetAction(this.ID, card.ID));
	}

	// 出牌
	void PlayCard()
	{
		List<Card> temp = new List<Card>();

		// 能出场的卡牌全部出场
		for (int i = 0; i < waitCard.Count; i++)
		{
			Card card = waitCard[i];
			if (card.waitRound <= 0)
				temp.Add(card);
		}

		foreach (Card card in temp)
		{
			waitCard.Remove(card);
			fightCard.Add(card);

			// 记录Action
			Actions.Add(PlayCardAction.GetAction(this.ID, card.ID));

			// 卡牌出场消息
			card.OnPresent();
		}

		status = FigtherStatus.attack;
	}

	// 卡牌战斗
	void FightCard()
	{
		Card card;
		for (int i = 0; i < fightCard.Count; i++)
		{
			if (IsDead || rival.IsDead)
				return;

			// 卡牌战斗
			card = fightCard[i];
			if (card == null || card.IsDead)
				continue;

			card.DoAttack();
		}

		status = FigtherStatus.actionEnd;
	}

	void ActionEnd()
	{
		status = FigtherStatus.waiting;
	}

	/// <summary>
	/// 卡牌进入牌堆
	/// </summary>
	public void CardToCemetery(Card card)
	{
		fightCard.Remove(card);
		cemeteryCard.Add(card);
	}

	/// <summary>
	/// 卡牌进入牌堆
	/// </summary>
	public void CardToCardArea(Card card)
	{
		if (fightCard.Contains(card))
			fightCard.Remove(card);
		else if (waitCard.Contains(card))
			waitCard.Remove(card);
		else if (cemeteryCard.Contains(card))
			cemeteryCard.Remove(card);

		initialCard.Add(card);
	}

	/// <summary>
	/// 卡牌进入等待区
	/// </summary>
	public void CardToWait(Card card)
	{
		if (fightCard.Contains(card))
			fightCard.Remove(card);
		else if (initialCard.Contains(card))
			initialCard.Remove(card);
		else if (cemeteryCard.Contains(card))
			cemeteryCard.Remove(card);
		
		waitCard.Add(card);
	}

	/// <summary>
	/// 卡牌复活
	/// </summary>
	public void CardRevive(Card card)
	{
		cemeteryCard.Remove(card);
		fightCard.Add(card);
	}

	/// <summary>
	/// 回合结束处理
	/// </summary>
	public void RoundEnd()
	{
		foreach (Card card in waitCard)
		{
			if (card.waitRound > 0)
				card.waitRound --;
		}
	}

	/// <summary>
	/// 
	/// </summary>
	public List<BaseFighter> GetTargetByType(Card attacker, int targetType)
	{
		List<BaseFighter> targets = new List<BaseFighter>();
		int index = -1;
		switch ((SkillTargetType)targetType)
		{
		case SkillTargetType.TARGET_SELF_TYPE:
			targets.Add(attacker);
			break;
		case SkillTargetType.TARGET_SELF_FRONT_TYPE:
			index = fightCard.IndexOf(attacker);
			if (rival.fightCard.Count > index && rival.fightCard[index] != null && !rival.fightCard[index].IsDead)
				targets.Add(rival.fightCard[index]);
			break;
		case SkillTargetType.TARGET_SELF_FRONT_OR_FIGHTER:
			index = fightCard.IndexOf(attacker);
			if (rival.fightCard.Count > index && rival.fightCard[index] != null && !rival.fightCard[index].IsDead)
				targets.Add(rival.fightCard[index]);
			else
				targets.Add(rival);
			break;
		default:
			break;
		}

		return targets;
	}

	/// <summary>
	/// 返回同一个国家的卡牌
	/// </summary>
	public List<BaseFighter> GetTargetByCountry(int country)
	{
		List<BaseFighter> result = new List<BaseFighter>();
		foreach (Card card in allCard)
		{
			// TODO:判断相同国家
			result.Add(card);
		}

		return result;
	}
}


