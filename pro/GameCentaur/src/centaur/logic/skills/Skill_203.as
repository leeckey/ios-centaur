package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;

	/**
	 * 反射技能,魔法伤害无效,并对攻击方造成120点伤害
	 * 
	 */		
	public class Skill_203 extends BaseSkill
	{
		/**
		 * 伤害值 
		 */		
		public var damage:int;
		
		public function Skill_203(data:SkillData, card:BaseCardObj)
		{
			super(data, card);
		}
		
		/**
		 * 设置卡牌参数 
		 * @param data
		 * 
		 */	
		public override function initConfig(data:SkillData):void
		{
			// 设置公共信息
			super.initConfig(data);
			
			damage = data.param1 * data.skillLevel;
		}
		
		/**
		 * 监听法术伤害事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
				card.addEventListener(CardEvent.ON_PRE_SKILL_HURT, onPreSkillHurt);
		}
		
		/**
		 * 免疫攻击,造成攻击者120点伤害 
		 * @param event
		 * 
		 */		
		public function onPreSkillHurt(event:CardEvent):void
		{
			// 只对魔法技能起作用
			if (card.attackerSKill.magicType != SkillEnumDefines.SKILL_MAAGIC_TYPE)
				return;
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
			card.lastBeAttackVal = -1;
			trace("法术伤害无效");
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			
			var attacker:BaseCardObj = card.attacker;
			if (attacker != null && !attacker.isDead)
				attacker.onHurt(damage);
		}
		
		
	}
}