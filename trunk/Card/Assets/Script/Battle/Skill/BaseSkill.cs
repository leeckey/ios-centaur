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
		get { return skillData.skillType; }
	}

	// 卡牌释放技能类型
	public int TargetType
	{
		get { return skillData.selectTargetType; }
	}

	// 卡牌名称
	public string SkillName
	{
		get { return skillData.name; }
	}

	// BuffID
	public int BuffID
	{
		get { return skillData.buffID; }
	}

	// 卡牌配置数据,不能做修改
	SkillData skillData;

	// 技能所属的卡牌
	public CardFighter card;

	public BaseSkill()
	{
		card = null;
		skillData = null;
	}

	/// <summary>
	/// 构造函数
	/// </summary>
	public BaseSkill(CardFighter card, SkillData skillData, int[] skillParam)
	{
		// 设置卡牌自带参数
		SetSkillParam(skillParam);

		// 设置配置参数
		InitConfig(skillData);

		// 设置技能关联
		RegisterCard(card);
	}

	/// <summary>
	/// 卡牌自带技能参数,一般第一个参数是技能级别
	/// </summary>
	protected void SetSkillParam(int[] skillParam)
	{
		if (skillParam == null || skillParam.Length == 0)
			return;

		skillLevel = skillParam[0];
	}

	/// <summary>
	/// 设置参数
	/// </summary>
	protected virtual void InitConfig(SkillData skillData)
	{
		this.skillID = skillData.id;
		this.skillData = skillData;
	}

	/// <summary>
	/// 注册卡牌
	/// </summary>
	public virtual void RegisterCard(CardFighter card)
	{
		this.card = card;
	}

	public virtual void RemoveCard(CardFighter card)
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

		List<BaseFighter> targetList = card.owner.GetTargetByType(this, TargetType);

		if (targetList.Count == 0)
			return;

		List<int> cardIDs = GetTargetID(targetList);
		card.Actions.Add(SkillStartAction.GetAction(card.ID, skillID, cardIDs));

		foreach (BaseFighter target in targetList)
		{
			if (target != null && !target.IsDead)
				_DoSkill(target);
		}

		// card.Actions.Add(SkillEndAction.GetAction(card.ID, skillID));
	}

	/// <summary>
	/// 卡牌转换为卡牌ID
	/// </summary>
	protected List<int> GetTargetID(List<BaseFighter> targets)
	{
		List<int> result = new List<int>();
		foreach (BaseFighter card in targets)
		{
			if (card == null)
				continue;
			result.Add(card.ID);
		}

		return result;
	}
	protected List<int> GetTargetID(BaseFighter target)
	{
		List<int> result = new List<int>();
		result.Add(target.ID);
		
		return result;
	}

	/// <summary>
	/// 技能实际效果,用于子类重载
	/// </summary>
	protected virtual void _DoSkill(BaseFighter target)
	{

	}
}
