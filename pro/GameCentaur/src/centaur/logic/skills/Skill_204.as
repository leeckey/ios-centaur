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
	 * 受攻击时50%概率闪避
	 * @author liq
	 * 
	 */	
	public class Skill_204 extends BaseSkill
	{
		/**
		 * 闪避的概率
		 */		
		public var rate:Number;
		
		public function Skill_204(data:SkillData, card:BaseCardObj)
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
			
			rate = (data.param1 + data.param2 * data.skillLevel) / 100;
		}
		
		/**
		 * 监听被普通攻击事件
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_PRE_HURT, onPreHurt, false, _priority);
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
				card.removeEventListener(CardEvent.ON_PRE_HURT, onPreHurt);
			}
			
			super.removeCard();
		}
		
		/**
		 * 概率闪避攻击
		 * @param event
		 * 
		 */		
		public function onPreHurt(event:CardEvent):void
		{
			if (card.lastBeAttackVal > 0 && Math.random() < rate)
			{				
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
				card.lastBeAttackVal = -1;
				trace(card.objID + "闪避了攻击");
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			}
		}
	}
}