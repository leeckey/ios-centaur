package centaur.utils
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.system.Capabilities;
    import flash.utils.ByteArray;
    import flash.utils.Proxy;
    
    import mx.utils.ObjectUtil;

    /**
    *  公共的工具类
    *  @author wangq 2010.05.12
    */ 
    public final class PublicUtil
    {
        public static const INVERSE_HALF_DEGREE:Number = 0.00555556;
        
        public static const INVERSE_PI:Number = 0.318309886;
        
        public static const HOUR:int = 3600;
        
        public static const MINITE:int = 60;
        
        public static function UT_ASSERT(obj:*, msg:String = "error", ...params):void
        {
            // 只使用与debug模式下
            if (! Capabilities.isDebugger)
                return;
            
//            if (! obj)
//                Logger.requestError(msg, params);
        }
        
        public static function UT_VERIFY(obj:*, msg:String = "error", ...params):void
        {
            // 所有模式下都会执行
//            if (! obj)
//                Logger.requestError(msg, params);
        }
        
        public static function numberCompare(a:Number, b:Number, epsilon:Number = 0.0001):Boolean
        {
            var delta:Number = a - b;
            return !(delta >= epsilon || delta <= -epsilon);
        }
        
        public static function pointCompare(a:Point, b:Point, epsilon:Number = 0.0001):Boolean
        {
            return numberCompare(a.x, b.x, epsilon) && numberCompare(a.y, b.y, epsilon);
        }
        
        public static function clamp(v:Number, min:Number = 0, max:Number = 1):Number
        {
            if(v < min) return min;
            if(v > max) return max;
            return v;
        }
        
        public static function getClass(item:*):Class
        {
            if(item is Class || item == null)
                return item;
            
            return Object(item).constructor;
        }
        
        public static function centerSelf(target:DisplayObject):void
        {
            if (target)
            {
                target.x = -target.width * 0.5;
                target.y = -target.height * 0.5;
            }
        }
        
        /**
         * 度弧度转度弧度
         */
        public static function getDegreesFromRadians(radians:Number):Number
        {
            return radians * 180 * INVERSE_PI;
        }
        
        /**
        * 度转弧度
        */ 
        public static function getRadiansFromDegrees(degrees:Number):Number
        {
            return degrees * Math.PI * INVERSE_HALF_DEGREE;
        }
        
        /**
        *  四舍五入
        */
        public static function floor(value:Number):Number
        {
            return (value + (value > 0 ? 0.5 : -0.5))|0;
        }
        
        /**
         *  对point四舍五入
         */
        public static function floorPoint(point:Point):Point
        {
            if (!point)
                return null;
            
            point.x = (point.x + (point.x > 0 ? 0.5 : -0.5))|0;
            point.y = (point.y + (point.y > 0 ? 0.5 : -0.5))|0;
            
            return point;
        }
        
        /**
        *  深度拷贝
        */ 
        public static function depthCopyObject(object:*):*
        {
            var bytes:ByteArray = new ByteArray();
            bytes.writeObject(object);
            bytes.position = 0;
            
            return bytes.readObject();
        }
        
        /**
        *  克隆二进制数组
        */
        public static function cloneByteArray(srcBytes:ByteArray):ByteArray
        {
            if (!srcBytes)
                return null;
            
            var result:ByteArray = new ByteArray();
            var oldPos:int = srcBytes.position;
            srcBytes.position = 0;
            srcBytes.readBytes(result);
            srcBytes.position = oldPos;
            
            return result;
        }
        
        /**
         * 创建一个对象并赋初值
         * 同样的功能也能通过创建ClassFactory代替
         * 
         * @param obj    一个对象的实例或者一个类，类会自动实例化。
         * @param values    初值对象
         * @return 
         * 
         */
        public static function createObject(obj:*,values:Object):*
        {
            if (obj is Class)
                obj = new obj();
            
            for (var key:* in values)
                obj[key] = values[key];
            
            return obj;
        }
        
        /**
        *  深度拷贝一个对象的属性到另一个对象
        *  @param src 属性拷贝源
        *  @param dest 属性拷贝终
        *  @param excludes 排除的属性
        *  @param options 而外选项，具体参考ObjectUtil.getClassInfo 
        */ 
        public static function copyProperties(src:Object, dest:Object, excludes:Array = null, options:Object = null):Boolean
        {
            if (!src || !dest)
                return false;
            
            // 如果是对象代理类，ObjectUtil直接报错
            if (src is Proxy)
                src = src.valueOf();
                        
            // 遍历赋值
            var propInfo:Array = getObjectProperties(src);
            if (!propInfo)
                return false;
            
            for each (var key:* in propInfo)
            {
                dest[key] = src[key];
            }
            
            return true;
        }
        
        /**
        *  深度拷贝一个对象的属性到另一个对象，如果对象属性是默认值，则不拷贝
        */
        public static function copyNoDefaultProperties(src:Object, dest:Object, excludes:Array = null, options:Object = null):Boolean
        {
            var srcClass:Class = getClass(src);
            if (!srcClass)
                return false;
            
            var defaultObject:* = new srcClass();
            var propInfo:Array = getObjectProperties(defaultObject);
            if (!propInfo)
                return false;
            
            for each (var key:* in propInfo)
            {
                var keyName:String = key;
                if (!keyName)
                    continue;
                
                if (excludes && excludes.indexOf(keyName) != -1)
                    continue;
                
                // 针对protobuf
                var firstChar:String = keyName.charAt(0);
                var length:int = keyName.length;
                keyName = ["has", firstChar.toUpperCase(), (length > 1 ? keyName.slice(1, keyName.length) : "")].join("");
                
                var srcValue:* = src[key];
                if (src.hasOwnProperty(keyName))
                {
                    if (src[keyName])
                        dest[key] = srcValue;
                    continue;
                }
                
                // 如果是数组，深度判断是否相同，如果不相同则直接认为不是默认值，需要copy
                var defaultValue:* = defaultObject[key];
                if (srcValue is Array)
                {
                    if (!compareArray(srcValue as Array, defaultValue))
                        dest[key] = srcValue;
                }
                else 
                    if (defaultValue != srcValue)
                    dest[key] = srcValue;
            }
            
            return true;
        }
        
        /**
         *  获取对象的属性列表
         */
        public static function getObjectProperties(obj:Object, excludes:Array = null, options:Object = null):Array
        {
            // 对象不存在，直接返回
            if (!obj)
                return null;
            
            // 如果
            if (!options)
                options = {includeReadOnly : false};
            
            // 获取属性
            var obj:Object = ObjectUtil.getClassInfo(obj, excludes, options);
            if (!obj)
                return null;
            
            return obj["properties"] as Array;
        }
        
        /**
        *  设置属性到目标对象上
        */
        public static function setProperties(properties:Object, target:Object):void
        {
            if (!properties || !target)
                return;
            
            for (var key:* in properties)
            {
                if (target.hasOwnProperty(key))
                    target[key] = properties[key];
            }
        }
        
        /**
        *  交换数组中的两个值
        */
        public static function swapArray(arr:Array, i:int, j:int):void
        {
            if (!arr ||
                i < 0 || i >= arr.length ||
                j < 0 || j >= arr.length)
                return;
            
            var valueA:* = arr[i];
            var valueB:* = arr[j];
            arr[i] = valueB;
            arr[j] = valueA;
        }
        
        /**
        *  深度比较数组是否相等，而不只是比较对象
        */
        public static function compareArray(arr1:Array, arr2:Array):Boolean
        {
            if (arr1 == arr2)
                return true;
            
            if (null == arr1 || null == arr2)
                return false;
            
            var length:int = arr1.length;
            if (length != arr2.length)
                return false;
            
            for (var i:int = 0; i < length; ++i)
            {
                if (arr1[i] != arr2[i])
                    return false;
            }
            
            return true;
        }
        
        /**
        *  判断是否是父子关系
        */
        public static function isParent(child:DisplayObject, parent:DisplayObject):Boolean
        {
            if (!child || !parent)
                return false;
            
            var tempParent:DisplayObject = child.parent;
            while (tempParent != null && tempParent != parent)
                tempParent = tempParent.parent;
            
            return tempParent != null;
        }
        
        
        
        /**
         *  判断数组过滤结果
         */
        public static function checkFilter(filters:Array, value:*):Boolean
        {
            if (!filters || (filters.length == 0))
                return false;
            
            return filters.indexOf(value) != -1;
        }
        
        /**
        *  int转String，保留median位
        */
        public static function IntToString(intValue:int, median:int = 0):String
        {
            var strArray:Array = intValue.toString().split("");
            if (median > strArray.length)
            {
                strArray.unshift("0");
            }
            
            return strArray.join("");
        }
        
        /**
        *   统计二进制中1的数量
        */ 
        public static function countBinaryOne(value:int):int
        {
            value = (value & 0x55555555) + ((value >> 1) & 0x55555555);
            value = (value & 0x33333333) + ((value >> 2) & 0x33333333);
            value = (value & 0x0f0f0f0f) + ((value >> 4) & 0x0f0f0f0f);
            value = (value & 0x00ff00ff) + ((value >> 8) & 0x00ff00ff);
            value = (value & 0x0000ffff) + ((value >> 16) & 0x0000ffff);
            return value;
        }
        
        public static function getFormatTime(time:int):Object
        {
            var formatTime:Object = {};
            formatTime.hour = (time / HOUR)|0;
            formatTime.minute = ((time % HOUR) / MINITE)|0;
            formatTime.second = ((time % HOUR) % MINITE)|0;
            
            return formatTime;
        }
        
    }
}