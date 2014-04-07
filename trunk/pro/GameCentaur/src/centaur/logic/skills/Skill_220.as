package centaur.logic.skills
{
	import centaur.data.buff.*;
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.buff.BaseBuff;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * 燃烧:受到物理攻击时,使对方燃烧,在其每次行动结束后丢失25点生命值 
	 * @author liq
	 * 
	 */	
	public class Skill_220 extends BaseSkill
	{
		/**
		 * 燃烧伤害值 
		 */		
		public var damage:int;
		
		private var buff:Class;
		
		public function Skill_220(data:SkillData, card:BaseCardObj, skillPara:Array)
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
			
			damage = data.param1;
			
			if (data.buffID != 0)
			{
				buffID = data.buffID;
				buff = getDefinitionByName("centaur.logic.buff.Buff_" + BuffDataList.getBuffData(buffID).templateID) as Class;
			}
		}
		
		/**
		 * 监听受到技能伤害事件 
		 * @param card
		 * 
		 */		
		public override function registerCard(card:BaseCardObj):void
		{
			super.registerCard(card);
			
			if (card != null)
			{
				card.addEventListener(CardEvent.ON_AFTER_HURT, onAfterHurt, false, _priority);
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
				card.removeEventListener(CardEvent.ON_AFTER_HURT, onAfterHurt);
			}
			
			super.removeCard();
		}
		
		/**
		 * 给予燃烧状态
		 * @param event
		 * 
		 */		
		public function onAfterHurt(event:CardEvent):void
		{
			// 已经有同等级相同的buff就不处理
			var attacker:BaseCardObj = card.attacker;
			var buffs:Array = attacker.buffs;
			for (var i:int = 0; i < buffs.length; i++)
			{
				var bf:BaseBuff = buffs[i];
				if (bf.id == this.buffID && bf.level == skillLevel && bf.round > 0)
					return;
			}
			
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, [card.attacker.objID]));
			
			var hurt:int = card.attacker.onSkillHurt(this, 0);
			if (hurt >= 0 && buffID > 0 && !card.attacker.isDead)
			{
				var data:BuffData = BuffDataList.getBuffData(buffID);
				data.param1 = damage;
				data.level = skillLevel;
				new buff(card.attacker, data);
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
			
			return desc.replace("{0}", (damage*skillLevel).toString());
		}
	}
}