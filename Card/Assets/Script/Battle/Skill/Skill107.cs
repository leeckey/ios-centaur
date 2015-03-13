using UnityEngine;
using System.Collections;

/// <summary>
///	瘟疫技能:使对方所有卡牌丧失10点攻击力和生命值
/// </summary>
public class Skill107 : BaseSkill
{
	// 攻击伤害
	int damage;
	
	public Skill107(CardFighter card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}
	
	protected override void InitConfig(SkillData skillData)
	{
		base.InitConfig (skillData);
		
		damage = skillLevel * skillData.param1;
	}
	
	protected override void _DoSkill(BaseFighter target)
	{
		if (!target.CanDoSkill())
			return;

		// 给自己加血
		target.OnSkillHurt(this, damage);
		target.DeductAttack(damage);
	}
}
