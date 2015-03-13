using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// 战斗玩家数据
/// </summary>
public class PlayerFighter : BaseFighter
{
	// 基础属性
	public string name;
	public int maxHp;
	
	// 是否自动
	public bool auto = true;

	// 所有卡牌
	public List<CardFighter> allCard;

	// 初始卡组
	List<CardFighter> initialCard;

	// 等待卡组
	List<CardFighter> waitCard;

	// 战斗卡组
	List<CardFighter> fightCard;

	// 墓地卡组
	List<CardFighter> cemeteryCard;

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

	public PlayerFighter()
	{
		allCard = new List<CardFighter>();
		initialCard = new List<CardFighter>();
		waitCard = new List<CardFighter>();
		fightCard = new List<CardFighter>();
		cemeteryCard = new List<CardFighter>();
	}

	/// <summary>
	/// 战斗对手
	/// </summary>
	PlayerFighter rival;
	public PlayerFighter Rival
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

		CardFighter card = initialCard[Random.Range(0, initialCard.Count)];

		card.DoWait();
	}

	// 出牌
	void PlayCard()
	{
		List<CardFighter> temp = new List<CardFighter>();

		// 能出场的卡牌全部出场
		for (int i = 0; i < waitCard.Count; i++)
		{
			CardFighter card = waitCard[i];
			if (card.waitRound <= 0)
				temp.Add(card);
		}

		foreach (CardFighter card in temp)
		{
			waitCard.Remove(card);
			fightCard.Add(card);

			// 卡牌出场消息
			card.OnPresent();
		}

		status = FigtherStatus.attack;
	}

	// 卡牌战斗
	void FightCard()
	{
		CardFighter card;
		for (int i = 0; i < fightCard.Count; i++)
		{
			if (IsDead || rival.IsDead)
				return;

			// 卡牌战斗
			card = fightCard[i];
			if (card == null || card.IsDead)
				continue;

			card.Action();
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
	public void CardToCemetery(CardFighter card)
	{
		fightCard.Remove(card);
		cemeteryCard.Add(card);
	}

	/// <summary>
	/// 卡牌进入牌堆
	/// </summary>
	public void CardToCardArea(CardFighter card)
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
	public void CardToWait(CardFighter card)
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
	public void CardRevive(CardFighter card)
	{
		cemeteryCard.Remove(card);
		fightCard.Add(card);

		// 卡牌出场
		card.OnPresent();
	}

	/// <summary>
	/// 回合结束处理
	/// </summary>
	public void RoundEnd()
	{
		foreach (CardFighter card in waitCard)
		{
			if (card.waitRound > 0)
				card.waitRound --;
		}
	}

	/// <summary>
	/// 根据类型选择攻击对象
	/// </summary>
	public List<BaseFighter> GetTargetByType(BaseSkill skill, int targetType)
	{
		CardFighter attacker = skill.card;
		List<CardFighter> temp = new List<CardFighter>();
		List<BaseFighter> targets = new List<BaseFighter>();
		CardFighter tempCard = null;
		int index = -1;
		int i = 0;

		switch ((SkillTargetType)targetType)
		{
		case SkillTargetType.TARGET_SELF_TYPE:
			// 自身
			targets.Add(attacker);
			break;
		case SkillTargetType.TARGET_SELF_FRONT_TYPE:
			// 自身对面
			index = fightCard.IndexOf(attacker);
			if (rival.fightCard.Count > index && rival.fightCard[index] != null && !rival.fightCard[index].IsDead)
				targets.Add(rival.fightCard[index]);
			break;
		case SkillTargetType.TARGET_SELF_FRONT3_TYPE:
			// 自身对面3个，左边各扩展一个
			index = fightCard.IndexOf(attacker);
			if (rival.fightCard.Count > index && rival.fightCard[index] != null && !rival.fightCard[index].IsDead)
				targets.Add(rival.fightCard[index]);
			if (index > 0 && rival.fightCard.Count > index-1 && rival.fightCard[index-1] != null && !rival.fightCard[index-1].IsDead)
				targets.Add(rival.fightCard[index-1]);
			if (rival.fightCard.Count > index+1 && rival.fightCard[index+1] != null && !rival.fightCard[index+1].IsDead)
				targets.Add(rival.fightCard[index+1]);
			break;
		case SkillTargetType.TARGET_RANDOM_TYPE:
			// 随机一个
			fightCard.ForEach(card => { if (card != null) temp.Add(card); });
			if (temp.Count > 0)
				targets.Add(temp[Random.Range(0, temp.Count)]);
			break;
		case SkillTargetType.TARGET_RANDOM2_TYPE:
			// 随机二个
			fightCard.ForEach(card => { if (card != null) temp.Add(card); });

			while (i < 2 && temp.Count > 0)
			{
				tempCard = temp[Random.Range(0, temp.Count)];
				targets.Add(tempCard);
				temp.Remove(tempCard);
				i++;
			}
			break;
		case SkillTargetType.TARGET_RANDOM3_TYPE:
			// 随机三个
			fightCard.ForEach(card => { if (card != null) temp.Add(card); });

			while (i < 3 && temp.Count > 0)
			{
				tempCard = temp[Random.Range(0, temp.Count)];
				targets.Add(tempCard);
				temp.Remove(tempCard);
				i++;
			}
			break;
		case SkillTargetType.TARGET_MIN_HP_TYPE:
			// 血量最少的一个
			int minHP = int.MaxValue;
			foreach (CardFighter card in fightCard)
			{
				if (card != null && card.HP < minHP)
					tempCard = card;
			}
			if (tempCard != null)
				targets.Add(tempCard);
			break;
		case SkillTargetType.TARGET_MAX_LOSE_HP_TYPE:
			// 掉血最多的一个
			foreach (CardFighter card in fightCard)
			{
				if (card != null && card.MaxHP - card.HP > maxHp)
					tempCard = card;
			}
			if (tempCard != null)
				targets.Add(tempCard);
			break;
		case SkillTargetType.TARGET_ALL_TYPE:
			// 对方所有
			fightCard.ForEach(card => { targets.Add(card); });
			break;
		case SkillTargetType.TARGET_RANDOM_CURE:
			// 随机一个可以治疗的目标
			fightCard.ForEach(card => { if (card != null && card.MaxHP != card.HP) temp.Add(card); });
			if (temp.Count > 0)
				targets.Add(temp[Random.Range(0, temp.Count)]);
			break;
		case SkillTargetType.TARGET_ALL_CURE:
			// 所有HP不满的卡牌
			fightCard.ForEach(card => { if (card != null && card.MaxHP != card.HP) targets.Add(card); });
			break;
		case SkillTargetType.TARGET_SAME_COUNTRY:
			// 除自己外相同国家的卡牌
			fightCard.ForEach(card => { if (card != null && card.cardData.country == attacker.cardData.country) targets.Add(card); });
			break;
		case SkillTargetType.TARGET_SELF_HURT_TYPE:
			// 自身受伤状态
			if (attacker.HP != attacker.MaxHP)
				targets.Add(attacker);
			break;
		case SkillTargetType.TARGET_MY_HERO:
			// 自身英雄
			targets.Add(this);
			break;
		case SkillTargetType.TARGET_ENEMY_HERO:
			// 对方英雄
			targets.Add(rival);
			break;
		case SkillTargetType.TARGET_COUNTRY_1:
			fightCard.ForEach(card => { if (card != null && card.cardData.country == (int)CardCountry.CARD_COUNTRY_SHU) targets.Add(card); });
			break;
		case SkillTargetType.TARGET_COUNTRY_2:
			fightCard.ForEach(card => { if (card != null && card.cardData.country == (int)CardCountry.CARD_COUNTRY_WEI) targets.Add(card); });
			break;
		case SkillTargetType.TARGET_COUNTRY_3:
			fightCard.ForEach(card => { if (card != null && card.cardData.country == (int)CardCountry.CARD_COUNTRY_WU) targets.Add(card); });
			break;
		case SkillTargetType.TARGET_COUNTRY_4:
			fightCard.ForEach(card => { if (card != null && card.cardData.country == (int)CardCountry.CARD_COUNTRY_QUN) targets.Add(card); });
			break;
		case SkillTargetType.MAX_ROUND_WAIT:
			int maxRound = 0;
			waitCard.ForEach(card => { if (card.waitRound > maxRound) tempCard = card; });
			if (tempCard != null)
				targets.Add(tempCard);
			break;
		case SkillTargetType.NO_BUFF_RANDOM:
			fightCard.ForEach(card => { if (card != null && !card.HasBuff(skill.BuffID)) temp.Add(card); });
			if (temp.Count > 0)
				targets.Add(temp[Random.Range(0, temp.Count)]);
			// 随机1个没有相同buff的卡牌
			break;
		case SkillTargetType.NO_BUFF_RANDOM2:
			fightCard.ForEach(card => { if (card != null && !card.HasBuff(skill.BuffID)) temp.Add(card); });
			while (i < 2 && temp.Count > 0)
			{
				tempCard = temp[Random.Range(0, temp.Count)];
				targets.Add(tempCard);
				temp.Remove(tempCard);
				i++;
			}
			// 随机2个没有相同buff的卡牌
			break;
		case SkillTargetType.NO_BUFF_RANDOM3:
			fightCard.ForEach(card => { if (card != null && !card.HasBuff(skill.BuffID)) temp.Add(card); });
			while (i < 3 && temp.Count > 0)
			{
				tempCard = temp[Random.Range(0, temp.Count)];
				targets.Add(tempCard);
				temp.Remove(tempCard);
				i++;
			}
			// 随机3个没有相同buff的卡牌
			break;
		case SkillTargetType.NO_BUFF_ALL:
			fightCard.ForEach(card => { if (card != null && !card.HasBuff(skill.BuffID)) targets.Add(card); });
			// 所有没有相同buff的卡牌
			break;
		case SkillTargetType.TARGET_SELF_FRONT_OR_FIGHTER:
			// 对面卡牌或者对方英雄
			index = fightCard.IndexOf(attacker);
			if (rival.fightCard.Count > index && rival.fightCard[index] != null && !rival.fightCard[index].IsDead)
				targets.Add(rival.fightCard[index]);
			else
				targets.Add(rival);
			break;
		case SkillTargetType.TARGET_SELF_FRONT3_OR_FIGHTER:
			// 自身对面3个，左边各扩展一个,没有返回对手
			index = fightCard.IndexOf(attacker);
			if (rival.fightCard.Count > index && rival.fightCard[index] != null && !rival.fightCard[index].IsDead)
				targets.Add(rival.fightCard[index]);
			if (index > 0 && rival.fightCard.Count > index-1 && rival.fightCard[index-1] != null && !rival.fightCard[index-1].IsDead)
				targets.Add(rival.fightCard[index-1]);
			if (rival.fightCard.Count > index+1 && rival.fightCard[index+1] != null && !rival.fightCard[index+1].IsDead)
				targets.Add(rival.fightCard[index+1]);

			if (targets.Count == 0)
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
		foreach (CardFighter card in allCard)
		{
			// TODO:判断相同国家
			result.Add(card);
		}

		return result;
	}
	
}


