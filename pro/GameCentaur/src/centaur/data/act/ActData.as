package centaur.data.act
{
	import centaur.utils.Utils;

	/**
	 *   任何一个作战对象的数据
	 */ 
	public class ActData
	{
		public var templateID:uint;		                // 模板ID
		public var cardList:Array = Utils.EMPTY_ARRAY;		// 卡组
		public var headPicID:int;		                    // 头像资源
		public var maxHP:uint;				                // 最大血量
		
		public function ActData()
		{
		}
		
		public function getCombatCardList():Array
		{
			return cardList;
		}
		
		
	}
}