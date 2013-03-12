package centaur.logic.action
{
	import flash.utils.ByteArray;

	public class ActionBase
	{
		public var type:int;
		public var srcObj:uint;
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
	}
}