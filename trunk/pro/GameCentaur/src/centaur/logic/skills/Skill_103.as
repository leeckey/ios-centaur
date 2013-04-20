package centaur.logic.skills
{
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillEnumDefines;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.*;
	import centaur.logic.buff.Buff_100;
	import centaur.logic.combat.CombatLogic;
	import centaur.logic.events.CardEvent;
	
	/**
	 * 冰弹：使一张或者多张卡牌受到100点伤害，30%概率下一回合无法行动 
	 * @author liq
	 * 
	 */	
	public class Skill_103 extends BaseSkill
	{
		/**
		 * buff类型 
		 */		
		private var buffClass:Buff_100;
		
		/**
		 * 伤害值 
		 */		
		public var damage:int;
		
		/**
		 * buff触发概率 
		 */		
		public var rate:Number;
		
		
		public function Skill_103(data:SkillData, card:BaseCardObj)
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
			
			damage = data.param1;
			rate = data.param2 / 100;
		}
		
		public override function doSkill():void
		{
			if (!card || card.isDead)
				return;
			
			var target:Array = getTarget();
			if (target == null || target.length == 0)
				return;
			
			CombatLogic.combatList.push(SkillStartAction.getAction(card.objID, skillID, makeIDArray(target)));
			CombatLogic.combatList.push(SkillEndAction.getAction(card.objID, skillID));
			
			var targetCard:BaseCardObj;
			for (var i:int = 0; i < target.length; i++)
			{
				targetCard = target[i] as BaseCardObj;
				if (targetCard != null)
				{
					targetCard.onSkillHurt(this, damage);
					if (Math.random() < rate)
					{
						trace("卡牌" + targetCard.objID + "被冻结");
						new Buff_100(targetCard);
					}
				}
			}
		}

	}
}