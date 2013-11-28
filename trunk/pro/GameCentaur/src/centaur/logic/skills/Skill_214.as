package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 背刺:出场回合额外增加200点攻击力（类似降临系技能）
	 * @author liq
	 * 
	 */	
	public class Skill_214 extends BaseSkill
	{
		/**
		 * 增加的攻击力 
		 */		
		public var attack:Number;
		
		public function Skill_214(data:SkillData, card:BaseCardObj, skillPara:Array)
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
				card.addEventListener(CardEvent.ON_PRESENT, onPresent, false, _priority);
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
				card.removeEventListener(CardEvent.ON_PRESENT, onPresent);
			}
			
			super.removeCard();
		}
		
		/**
		 * 增加200攻击力
		 * @param event
		 * 
		 */		
		public function onPresent(event:CardEvent):void
		{
			card.addEventListener(CardEvent.ON_ROUND_END, onRoundEnd);
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.objID]));
			card.addAttack(attack);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
		
		/**
		 * 回合结束攻击力还原 
		 * @param event
		 * 
		 */		
		public function onRoundEnd(event:CardEvent):void
		{
			card.removeEventListener(CardEvent.ON_ROUND_END, onRoundEnd);
			card.deductAttack(attack);
		}
	}
}