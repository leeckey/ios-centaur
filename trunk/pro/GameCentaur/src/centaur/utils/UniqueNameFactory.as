package centaur.utils
{
	import flash.utils.Dictionary;

    /**
    *  唯一名称生成工厂
    *  @author wangq 2012.06.20
    */ 
    public final class UniqueNameFactory
    {
		public static var UniqueObjDic:Dictionary = new Dictionary();
		
        /**
        *  对象唯一ID号
        */ 
        private static var _uniqueCount:int = 1;
        
        /**
        *  生成唯一的名称
        *  @param prefix 名称前缀
        */ 
        public static function getUniqueName(prefix:String = ""):String
        {
            return prefix + "_" + String(_uniqueCount++);
        }
		
		public static function getUniqueID(obj:*, baseValue:uint = 0):uint
		{
			var id:uint = baseValue + _uniqueCount++;
			UniqueObjDic[id] = obj;
			return id;
		}
		
		public static function removeUniqueByID(id:uint):void
		{
			delete UniqueObjDic[id];
		}
    }
}