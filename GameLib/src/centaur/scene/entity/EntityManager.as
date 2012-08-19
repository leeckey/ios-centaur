package centaur.scene.entity
{
	import centaur.entity.IEntity;
	import centaur.scene.data.entity.EntityData;
	
	import com.citrusengine.core.CitrusObject;
	
	import flash.utils.Dictionary;

	/**
	 *   各种物体的对象池，负责管理、生成和回收
	 *   @author wangq 2012.08.11
	 */ 
	public final class EntityManager
	{
		private static var _instance:EntityManager;
		
		/** 对象池数据 */
		private static var _entityPool:Dictionary = new Dictionary();
		
		public static function get instance():EntityManager
		{
			if (!_instance)
				_instance = new EntityManager();
			
			return _instance;
		}
		
		public function getAvailableEntity(data:EntityData):CitrusObject
		{
			if (!data)
				return null;
			
			var obj:CitrusObject = popFromPool(data);
			if (!obj)
				obj = EntityFactory.getInstance(data);
			
			return obj;
		}
		
		public function recycleEntity(entity:CitrusObject):void
		{
			if (!entity)
				return;
			
			if (!entity)
				return;
			
			var entityData:EntityData = (entity is IEntity) ? (entity as IEntity).data as EntityData : null;
			if (!entityData)
			{
				// 析构掉对象
			}
			else
			{
				// 将对象推入对象池
				pushToPool(entity as IEntity, entityData);
			}
		}
		
		private function popFromPool(data:EntityData):CitrusObject
		{
			var entityType:int = data.entityType;
			var poolList:Array = _entityPool[entityType] as Array;
			if (!poolList)
				return null;
			
			return poolList.pop();
		}
		
		private function pushToPool(entity:IEntity, entityData:EntityData):void
		{
			var entityType:int = entityData.entityType;
			var poolList:Array = _entityPool[entityType] as Array;
			if (!poolList)
				poolList = _entityPool[entityType] = [entity];
			else
				poolList.push(entity);
		}
		
	}
}