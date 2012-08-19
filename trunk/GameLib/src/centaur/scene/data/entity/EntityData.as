package centaur.scene.data.entity
{
	import centaur.entity.IEntityData;

	public final class EntityData implements IEntityData
	{
		public var type:String = "";
		public var entityType:int;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var group:int;
		
		public var oneWay:Boolean;
		
		public function EntityData()
		{
		}
	}
}