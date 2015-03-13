using UnityEngine;
using System.Collections;

/// <summary>
/// 冰弹:使一张或者多张卡牌受到100点伤害,30%概率下一回合无法行动 
/// </summary>
public class Skill101 : BaseSkill
{
	// 伤害值
	int damage;

	// 中buff的概率
	int rate;

	public Skill101(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig (skillData);
		
		damage = skillData.param1 * skillLevel;
		rate = skillData.param2;
	}

	protected override void _DoSkill(BaseFighter target)
	{
		// 卡牌存在,攻击卡牌
		target.OnSkillHurt(this, damage);

		// 判定成功增加Buff
		if (target.canDoSkill && BuffID > 0 && !target.IsDead && Random.Range(0, 100) < rate)
		{
			BaseBuff buff = BuffFactory.GetBuffByID(BuffID, skillLevel);
			card.attacker.AddBuff(buff);
		}
	}
}
