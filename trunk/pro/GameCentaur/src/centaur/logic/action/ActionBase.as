package centaur.logic.action
{
	import flash.utils.ByteArray;

	public class ActionBase
	{
		public static const ACTION_SELECT_TO_WAITAREA:int = 1;		// 从卡堆移动卡牌到等待区
		public static const ACTION_SELECT_TO_COMBATAREA:int = 2;	    // 从等待区移动卡牌到战斗区
		public static const ACTION_SELECT_TO_CEMETERYAREA:int = 3;	// 将卡牌移动到墓地区
		public static const ACTION_ATTACK_EFFECT:int = 4;			    // 普通效果
		public static const ACTION_SKILL_START:int = 5;			    // 技能效果
		public static const ACTION_SKILL_END:int = 6;				    // 回合前阶段技能
		public static const ACTION_ROUND_START:int = 7;				// 新回合开始
		public static const ACTION_ROUND_END:int = 8;				    // 当前回合结束
		public static const ACTION_DAMAGE_NOTIFY:int = 9;			    // 专门处理伤害的操作类型
		public static const ACTION_BUFF_NOTIFY:int = 10;			    // BUFF操作类型
		public static const ACTION_ATTACK_CHANGE:int = 11;			// 攻击力变化操作
		public static const ACTION_CURE_NOTIFY:int = 12;			    // 血量增加
		public static const ACTION_SELECT_TO_CARDAREA:int = 13;	    // 将卡牌移动到卡堆区
		
		/**
		 * 类型 
		 */		
		public var type:int;
		
		/**
		 * 施放对象ID 
		 */		
		public var srcObj:uint;
		
		/**
		 * 作用对象ID 
		 */		
		public var targetObj:uint;
		
		public function ActionBase()
		{
		}
		
		public function loadData(data:ByteArray):void
		{
		}
		
		public function writeData(data:ByteArray):void
		{
			
		}
		
		/**
		 * 描述信息 
		 * @return 
		 * 
		 */		
		public function toString():String
		{
			return "这是一个Action";
		}
	}
}