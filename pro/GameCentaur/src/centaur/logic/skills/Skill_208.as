package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.events.CardEvent;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.action.*;
	
	/**
	 * 吸血:攻击造成物理伤害时，恢复伤害50%的生命值 
	 * @author liq
	 * 
	 */	
	public class Skill_208 extends BaseSkill
	{
		/**
		 * 吸血的比率 
		 */		
		public var rate:Number;
		
		public function Skill_208(data:SkillData, card:BaseCardObj)
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
			
			rate = data.param1 / 100;
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
		 * 攻击成功后吸取生命值
		 * @param event
		 * 
		 */		
		public function onAttackSucc(event:CardEvent):void
		{
			if (!card.isHurt)
				return;
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
			var hp:int = rate * card.lastDamageValue;
			card.addHP(hp);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
	}
}