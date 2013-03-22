package ghostcat.manager
{
    import flash.utils.Dictionary;
    
    import ghostcat.util.ReflectUtil;
    import ghostcat.util.core.Singleton;

/**
*�ṩ�˵���������ע�빦�ܣ���MVC�޹ء�
*����register���������ʵ��ע��
*InjectManager.instance.register(new Model(1),new Model(2));
*
*Ȼ������Ҫע�����ʾ����������ԣ�������InjectԪ��ǩ
*[Inject(id="1")]
*public var m1:Model;
*        
*[Inject(id="2")]
*public var m2:Model;
*
*���ڹ��캯������ʽ����InjectManager.instance.inject(this)�����ע�룬���ô˷��������m1,m2���Խ��ᱻ������ֵ��֮ǰע�����ʵ����
*[Inject]��ǩ�Ĳ�����Ϊ������ͬ���͵Ĳ�ͬʵ����[Inject(id="1")]��ʾֻ������id��ֵΪ1�Ķ���Żᱻע��������ԣ������Ȼ�ж�����������Ķ�����ȡ��һ�����������ֻ����һ��������Ҫ������
*
*�����ù�ViewManager.register(stage)ע�����̨��InjectManager����ͨ��ͬ���ķ�������ע����Ļ�д��ڵ���ʾ����
*ViewManager.register(stage,false)��2��������ʾ�Ƿ�������ͬ���͵Ĳ�ͬʵ��������Ϊtrue�������ĸ������ܡ�
*
*
*InjectManager��������ʵ�����ġ�
*/
    
    public class InjectManager extends Singleton
    {
        static public function get instance():InjectManager
        {
            return Singleton.getInstanceOrCreate(InjectManager) as InjectManager;
        }
        
        protected var dict:Dictionary;
        
        public function InjectManager()
        {
            super();
            
            dict = new Dictionary();
        }
        
        public function register(...reg):void
        {
            for (var i:int = 0;i < reg.length;i++)
            {
                var target:* = reg[i];
                var cls:* = target["constructor"];
                if (cls)
                {
                    var list:Array = dict[cls];
                    if (!list)
                        dict[cls] = list = [];
                        
                    list.push(target);
                }
            }
        }
        
        public function inject(target:*):void
        {
            var pList:Object = ReflectUtil.getPropertyTypeList(target,true);
            for (var p:String in pList)
            {
                var o:Object = ReflectUtil.getMetaDataObject(target,p,"Inject");
                if (o)
                    target[p] = retrieve(pList[p],o);
            }
        }
        
        public function retrieve(cls:Class,filter:Object = null):*
        {
            var list:Array = dict[cls];
            if (!list)
            {
                var vm:ViewManager = Singleton.getInstance(ViewManager);
                return vm ? vm.getView(cls,filter) : null;
            }
            
            if (filter)
            {
                for each (var v:Object in list)
                {
                    var match:Boolean = true;
                    for (var p:String in filter)
                    {
                        if (!(v.hasOwnProperty(p) && v[p] == filter[p]))
                        {
                            match = false;
                            break;
                        }
                    }
                    if (match)
                        return v;
                }
            }
            else
            {
                return list[0];
            }
            return null;
        }
    }
}