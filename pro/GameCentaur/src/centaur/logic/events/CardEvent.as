package centaur.logic.events
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.events.Event;

	/**
	 *   卡牌相关事件
	 */ 
	public final class CardEvent extends Event
	{
/*		public static const ON_MAGIC_SKILLER:String = "onMagicSkiller";
		public static const ON_MAGIC_HURT:String = "onMagicHurt";
		public static const ON_ATTACK_SKILLER:String = "onAttackSkiller";

		public static const ON_ATTACK_HURT:String = "onAttackHurt";
		public static const ON_SPEC_SKILLER:String = "onSpecSkiller";
		public static const ON_SPEC_HURT:String = "onSpecHurt";*/
		
		
		/**
		 * 出场事件 
		 */		
		public static const ON_INITIALIZE:String = "onInitialize";
		
		/**
		 * 出场事件 
		 */		
		public static const ON_PRESENT:String = "onPresent";
		
		/**
		 * 死亡事件 
		 */		
		public static const ON_DEAD:String = "onDead";
		
		/**
		 * 回合开始事件 
		 */		
		public static const ON_ROUND_START:String = "onRoundStart";
		
		/**
		 * 回合结束事件 
		 */		
		public static const ON_ROUND_END:String = "onRoundEnd";
		
		/**
		 * 普通攻击事件 
		 */		
		public static const ON_ATTACK:String = "onAttack";
		
		/**
		 * 普通攻击前事件 
		 */		
		public static const ON_PRE_ATTACK:String = "onPreAttack";
		
		/**
		 * 普通攻击后事件 
		 */		
		public static const ON_AFTER_ATTACK:String = "onAfterAttack";
		
		/**
		 * 普通攻击造成伤害事件 
		 */		
		public static const ON_ATTACK_SUCC:String = "onAttackSucc";
		
		/**
		 * 普通攻击伤害前事件 
		 */		
		public static const ON_PRE_HURT:String = "onPreHurt";
		
		/**
		 * 普通攻击伤害后事件 
		 */		
		public static const ON_AFTER_HURT:String = "onAfterHurt";
		
		/**
		 * 被技能攻击前事件 
		 */		
		public static const ON_PRE_SKILL_HURT:String = "onPreSkillHurt";
		
		/**
		 * 被技能攻击后事件 
		 */		
		public static const ON_AFTER_SKILL_HURT:String = "onAfterSkillHurt";
		
		/**
		 * 释放技能事件 
		 */		
		public static const ON_SKILL:String = "onSkill";
		
		
		/**
		 * 事件发出卡牌 
		 */		
		public var card:BaseCardObj;
		
		public function CardEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var evt:CardEvent = new CardEvent(type, bubbles, cancelable);
			evt.card = this.card;
			
			return evt;
		}
		
		/**
		 * 创建一个事件消息 
		 * @param type
		 * @param card
		 * @return 
		 * 
		 */		
		public static function EventFactory(type:String, card:BaseCardObj):CardEvent
		{
			var evt:CardEvent = new CardEvent(type);
			evt.card = card;
			
			return evt;
		}
	}
}