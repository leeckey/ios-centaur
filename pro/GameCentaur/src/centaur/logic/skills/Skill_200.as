package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 横扫技能,普通攻击时同时攻击对面左右三个目标 
	 * @author minnie
	 * 
	 */	
	public class Skill_200 extends BaseSkill
	{		
		public function Skill_200(data:SkillData, card:BaseCardObj)
		{
			super(data, card);
		}
		
		
		/**
		 * 监听攻击事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
				card.addEventListener(CardEvent.ON_ATTACK, onAttack, false, _priority);
		}
		
		/**
		 * 取消监听卡牌 
		 * @param card
		 * 
		 */		
		public override function removeCard():void
		{
			if (card != null)
				card.removeEventListener(CardEvent.ON_ATTACK, onAttack);
			
			super.removeCard();
		}
		
		/**
		 * 普通攻击处理 
		 * @param event
		 * 
		 */		
		private function onAttack(event:CardEvent):void
		{
			// 屏蔽普通攻击的事件
			event.stopImmediatePropagation();
			
			if (!card || card.isDead || card.attack <= 0)
				return;
			
			// 寻找目标
			var targets:Array = getTarget();
			
			// 发起攻击
			if (targets == null || targets.length == 0)
			{
				// 攻击对方玩家
				CombatLogic.combatList.push(AttackEffectAction.getAction(card.objID, card.owner.enemyActObj.objID));
				card.owner.enemyActObj.deductHp(card.attack);
			}
			else
			{
				// 攻击效果
				var targetCard:BaseCardObj;
				var targetID:Array = [];
				for (var i:int = 0; i < targets.length; i++)
				{
					targetCard = targets[i] as BaseCardObj;
					if (targetCard)
						targetID.push(targetCard.objID);
				}
				CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, targetID));
				CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
				
				// 攻击对面的卡牌
				targetCard = targets[0] as BaseCardObj;
				card.target = targetCard;
				targetCard.onAttackHurt(card, card.attack);
				
				// 中间卡牌的防御技能会影响到旁边二张卡牌,获得计算防御效果后的伤害值
				var tempAttack:int = card.lastDamageValue;
				
				if (tempAttack <= 0)
					return;
				
				// 对旁边二张卡牌进行攻击
				for (var j:int = 1; j < targets.length; j++)
				{
					targetCard = targets[j] as BaseCardObj;
					card.target = targetCard;
					targetCard.onAttackHurt(card, tempAttack);
				}
				
			}

		}
	}
}