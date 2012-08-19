package centaur.scene.entity.elements
{
	import centaur.entity.IEntity;
	import centaur.entity.IEntityData;
	import centaur.scene.data.entity.EntityData;
	
	import com.citrusengine.objects.NapePhysicsObject;

	public class EntityBase extends NapePhysicsObject implements IEntity
	{
		protected var _data:EntityData;
		
		public function EntityBase(name:String, params:Object = null)
		{
			super(name, params);
		}
		
		public function set data(data:IEntityData):void
		{
			if (_data != data)
			{
				_data = data as EntityData;
			}
		}
		
		public function get data():IEntityData
		{
			return _data;
		}
		
		override protected function setParams(object:Object):void
		{
			if (object is IEntityData)
			{
				_data = object as EntityData;
				updateProperties();
				_initialized = true;
			}
			else
				super.setParams(object);
		}
		
		protected function updateProperties():void
		{
			if (!_data)
				return;
			
			this.x = _data.x;
			this.y = _data.y;
			this.width = _data.width;
			this.height = _data.height;
			this.group = _data.group;
		}
	}
}