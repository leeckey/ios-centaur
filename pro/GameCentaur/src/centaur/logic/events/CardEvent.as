package centaur.logic.events
{
	import flash.events.Event;

	/**
	 *   卡牌相关事件
	 */ 
	public final class CardEvent extends Event
	{
		public static const ON_MAGIC_SKILLER:String = "onMagicSkiller";
		public static const ON_MAGIC_HURT:String = "onMagicHurt";
		public static const ON_ATTACK_SKILLER:String = "onAttackSkiller";
		public static const ON_ATTACK_HURT:String = "onAttackHurt";
		public static const ON_SPEC_SKILLER:String = "onSpecSkiller";
		public static const ON_SPEC_HURT:String = "onSpecHurt";
		public static const ON_PRESENT:String = "onPresent";
		public static const ON_DEAD:String = "onDead";
		public static const ON_ROUND_START:String = "onRoundStart";
		public static const ON_ROUND_END:String = "onRoundEnd";
		
		public function CardEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}