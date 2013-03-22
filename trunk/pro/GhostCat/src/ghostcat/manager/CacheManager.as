package ghostcat.manager
{
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import ghostcat.util.core.ClassFactory;
    import ghostcat.util.core.Singleton;
    
    /**
     * 对象缓存管理类。由它删除的对象不会被清除，可以在被创建的时候重新使用。
     * 
     * @author flashyiyi
     * 
     */
    public class CacheManager extends Singleton
    {
        static public function get instance():CacheManager
        {
            return Singleton.getInstanceOrCreate(CacheManager) as CacheManager;
        }
        
        public var dict:Dictionary = new Dictionary();
        
        public function CacheManager()
        {
            super();
        }
        
        /**
         * 创建一个对象
         * 
         * @return 
         * 
         */
        public function create(ref:Class, params:Array = null, properties:Object = null):*
        {
            var list:Array = dict[ref];
            if (list)
            {
                var obj:* = list.pop();
                if (list.length == 0)
                    delete dict[ref];
                return obj;
            }
            else
                return new ClassFactory(ref, properties, params).newInstance();
        }
        
        /**
         * 回收一个对象
         * 
         * @return 
         * 
         */        
        public function remove(obj:*):void
        {
            var ref:Class = obj.constructor as Class;
            if (!dict[ref])
                dict[ref] = [];
            (dict[ref] as Array).push(obj);
        }
        
        /**
         * 清除缓存
         * 
         * @return 
         * 
         */        
        public function clear(ref:Class = null):*
        {
            if (ref == null)
                dict = new Dictionary();
            else
                delete dict[ref];
        }
    }
}