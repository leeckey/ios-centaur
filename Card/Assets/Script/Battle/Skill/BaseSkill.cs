using System;
using System.Collections.Generic;

/// <summary>
/// 技能基类
/// </summary>
public class BaseSkill
{
	// 卡牌ID
	public int skillID;
	
	// 卡牌级别
	public int skillLevel;

	// 卡牌类型
	public int SkillType
	{
		get { return skillData.skillType; };
	}

	// 卡牌释放技能类型
	public int TargetType
	{
		get { return skillData.selectTargetType; };
	}

	// 卡牌名称
	public string SkillName
	{
		get { return skillData.name; };
	}

	// 卡牌配置数据,不能做修改
	SkillData skillData;

	// 技能所属的卡牌
	public Card card;

	public BaseSkill(Card card, SkillData skillData)
	{
		RegisterCard(card);

		this.skillData = skillData;
	}

	/// <summary>
	/// 注册卡牌
	/// </summary>
	public virtual void RegisterCard(Card card)
	{
		this.card = card;
	}

	public virtual void RemoveCard(Card card)
	{
		this.card = null;
	}

	/// <summary>
	/// 释放技能效果
	/// </summary>
	public virtual void DoSkill()
	{
		if (card == null || card.IsDead)
			return;

		List<BaseFighter> targetList = card.owner.GetTargetByType(card, targetType);

		if (targetList.Count == 0)
			return;

		List<int> cardIDs = GetTargetID(targetList);
		card.owner.Room.actions.Add(SkillStartAction.GetAction(card.ID, skillID, cardIDs));

		foreach (BaseFighter target in targetList)
		{
			_DoSkill(target);
		}

		card.owner.Room.actions.Add(SkillEndAction.GetAction(card.ID, skillID));
	}

	/// <summary>
	/// 卡牌转换为卡牌ID
	/// </summary>
	protected List<int> GetTargetID(List<BaseFighter> targets)
	{
		List<int> result = new List<int>();
		foreach (BaseFighter card in targets)
			result.Add(card.ID);

		return result;
	}

	/// <summary>
	/// 技能实际效果,用于子类重载
	/// </summary>
	protected virtual void _DoSkill(BaseFighter target)
	{

	}
}
