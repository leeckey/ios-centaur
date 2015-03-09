using UnityEngine;
using System.Collections;

/// <summary>
/// 燃烧:受到物理攻击时,使对方燃烧,在其每次行动结束后丢失25点生命值 
/// </summary>
public class Skill220 : BaseSkill
{
	public Skill220(Card card, SkillData skillData, int[] skillParam) : base(card, skillData, skillParam)
	{
		
	}

	// TODO 等buff做好
}
