package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	import flashx.textLayout.formats.Float;
	
	/**
	 * 暴击:攻击时有50几率提高100%攻击力 
	 * @author minnie
	 * 
	 */	
	public class Skill_201 extends BaseSkill
	{
		/**
		 * 暴击几率 
		 */		
		public var rate:Number;
		
		/**
		 * 暴击提升的攻击力 
		 */		
		public var attackUp:Number;
			
		private var tempAttack:int;
		
		
		public function Skill_201(data:SkillData, card:BaseCardObj)
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
			attackUp = data.param2;
			tempAttack = 0;
		}
		
		/**
		 * 监听攻击开始和结束的事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_PRE_ATTACK, onPreAttack, false, _priority);
				
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
				card.removeEventListener(CardEvent.ON_PRE_ATTACK, onPreAttack);
			}
			
			super.removeCard();
		}
		
		/**
		 * 攻击开始前判定暴击
		 * @param event
		 * 
		 */		
		public function onPreAttack(event:CardEvent):void
		{
			// 此技能只对卡牌有效
			var targets:Array = getTarget();
			if (targets == null)
				return;
			
			if (Math.random() < rate)
			{
				// 暴击判定成功
				tempAttack = card.attack * attackUp / 100;
				if (tempAttack > 0)
				{
					card.addEventListener(CardEvent.ON_AFTER_ATTACK, onAfterAttack, false, _priority);
					CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
					tempAttack = card.addAttack(tempAttack);
					CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
				}
			}
		}
		
		/**
		 * 攻击结束后还原暴击 
		 * @param event
		 * 
		 */		
		public function onAfterAttack(event:CardEvent):void
		{
			// 还原攻击力
			if (tempAttack > 0)
			{
				card.removeEventListener(CardEvent.ON_AFTER_ATTACK, onAfterAttack);
				card.deductAttack(tempAttack);
				tempAttack = 0;
			}
		}
	}
}