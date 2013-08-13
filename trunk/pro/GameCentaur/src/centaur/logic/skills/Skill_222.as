package centaur.logic.skills
{
	import centaur.data.buff.*;
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * 裂伤技能:当攻击并对敌方造成物理伤害时施放,使对方无法回春和被治疗 
	 * @author liq
	 * 
	 */	
	public class Skill_222 extends BaseSkill
	{
		/**
		 * BuffID 
		 */		
		public var buffID:int;
		
		private var buff:Class;
		
		public function Skill_222(data:SkillData, card:BaseCardObj)
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
			
			if (data.buffID != 0)
			{
				buffID = data.buffID;
				buff = getDefinitionByName("centaur.logic.buff.Buff_" + BuffDataList.getBuffData(buffID).templateID) as Class;
			}
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
		 * 裂伤技能Buff
		 * @param event
		 * 
		 */		
		public function onAttackSucc(event:CardEvent):void
		{

			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.target.objID]));
				
			var data:BuffData = BuffDataList.getBuffData(buffID);

			new buff(card.target, data);
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
		}
		
	}
}