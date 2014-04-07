package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 削弱：当对对方造成物理伤害时，减少对方20点攻击力 
	 * @author liq
	 * 
	 */	
	public class Skill_213 extends BaseSkill
	{
		/**
		 * 减少的攻击力 
		 */		
		public var attack:Number;
		
		public function Skill_213(data:SkillData, card:BaseCardObj, skillPara:Array)
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
		 * 降低目标20点攻击力
		 * @param event
		 * 
		 */		
		public function onAttackSucc(event:CardEvent):void
		{
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.target.objID]));
			
			if (card.target.onSkillHurt(this, 0) >= 0)
			{
				card.target.deductAttack(attack);
			}
			
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