package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 嗜血：每次攻击对方造成伤害时，提升30点攻击力 
	 * @author liq
	 * 
	 */	
	public class Skill_212 extends BaseSkill
	{
		/**
		 * 最大承受伤害 
		 */		
		public var attack:Number;
		
		public function Skill_212(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
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
			
			attack = data.param1 * skillLevel;
		}
		
		/**
		 * 监听事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_ATTACK_SUCC, onAttackSucc, false, _priority);
			}
		}
		
		/**
		 * 取消事件监听 
		 * 
		 */		
		public override function removeCard():void
		{
			if (card != null)
			{
				card.removeEventListener(CardEvent.ON_ATTACK_SUCC, onAttackSucc);
			}
			
			super.removeCard();
		}
		
		/**
		 * 提升30点攻击力
		 * @param event
		 * 
		 */		
		public function onAttackSucc(event:CardEvent):void
		{
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
			card.addAttack(attack);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
		
		/**
		 * 显示技能描述 
		 * @return 
		 * 
		 */		
		public override function getSkillDesc():String
		{
			var desc:String = super.getSkillDesc();
			
			return desc.replace("{0}", attack.toString());
		}
	}
}