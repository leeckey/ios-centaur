package centaur.scene.entity
{
	import centaur.scene.consts.EntityType;
	import centaur.scene.data.entity.EntityData;
	import centaur.scene.entity.elements.EntityBase;
	import centaur.scene.entity.elements.PlatformEntity;
	import centaur.utils.UniqueNameFactory;
	
	import com.citrusengine.core.CitrusObject;

	public final class EntityFactory
	{
		public static function getInstance(data:EntityData):CitrusObject
		{
			if (!data)
				return null;
			
			var type:int = data.entityType;
			switch (type)
			{
				case EntityType.NORMAL:
					return new EntityBase(UniqueNameFactory.getUniqueName(), data);
				case EntityType.PLATFORM:
					return new PlatformEntity(UniqueNameFactory.getUniqueName(), data);
			}
			
			return new EntityBase(UniqueNameFactory.getUniqueName(), data);
		}
	}
}