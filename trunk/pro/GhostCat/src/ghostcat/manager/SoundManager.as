package ghostcat.manager
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    
    import ghostcat.display.movieclip.GMovieClip;
    import ghostcat.operation.DelayOper;
    import ghostcat.operation.FunctionOper;
    import ghostcat.operation.Queue;
    import ghostcat.util.Tick;
    import ghostcat.util.core.Singleton;
    import ghostcat.util.easing.TweenUtil;
    
    /**
     * 声音管理类
     * 
     * @author flashyiyi
     * 
     */
    public class SoundManager extends Singleton
    {
        /**
        *  音乐类型
        */ 
        public static const MUSIC:String ="music";
        
        /**
        *  音效类型
        */ 
        public static const AUDIO:String = "audio";
        
        /**
        *  声音音效的前缀
        */ 
        public static const AUDIO_SUFFIX:String = "yx_";
        
        /**
         *  声音音乐的前缀
         */
        public static const MUSIC_SUFFIX:String = "yy_";
        
        /**
        *   默认的游戏声音
        */ 
        public var defaultSound:GMovieClip;
        
        static public function get instance():SoundManager
        {
            return Singleton.getInstanceOrCreate(SoundManager) as SoundManager;
        }
        
        private var _globalSounds:Dictionary = new Dictionary();
        
        /**
         * 声音类的默认包名
         */        
        public var basePath:String ="";
        
        /**
         * 默认声音大小
         */        
        public var defaultVolume:Number=1.0;
        
        private var activeSound:Dictionary;
        
        public function SoundManager():void
        {
            activeSound = new Dictionary();
            
            _globalSounds[MUSIC] = new Sprite();
            _globalSounds[AUDIO] = new Sprite();
        }
        
        /**
         * 设置全局声音的大小
         *  
         * @param volume    声音
         * @param pan    声音位置，范围由-1到1
         * @param len    变化需要的时间
         */    
        public function setGlobalVolume(volume:Number,len:Number=0):void
        {
            if (len==0)
                SoundMixer.soundTransform = new SoundTransform(volume);
            else
                TweenUtil.to(SoundMixer,len,{volume:volume})
        }
        
        /**
        *   淡出之前的声音，淡入指定的声音
        */ 
        private var _fadeQueue:Queue;
        public function fadeOutInSound(name:String, preSuffix:String = AUDIO_SUFFIX):void
        {
            SoundManager.instance.stopAll(1000);
            _fadeQueue = new Queue([new DelayOper(1200), new FunctionOper(fadeInSound, [name, preSuffix])]);
            _fadeQueue.execute();
        }
        
        
        private function fadeInSound(name:String, preSuffix:String = AUDIO_SUFFIX):void
        {
            setGlobalVolume(1, 1000);
            if (defaultSound)
                defaultSound.destory();
            defaultSound = generateAndActiveSoundMovie(name, preSuffix);
        }
        
        public function stopAll(len:Number = 2000):void
        {
            if (len <= 0)
                stopAllImpl();
            else
            {
                TweenUtil.to(SoundMixer,len,{volume:0, onComplete : stopAllImpl});
            }
        }
        
        private function stopAllImpl():void
        {
            SoundMixer.stopAll();
            
            // 默认的声音资源也清除掉
            if (defaultSound)
                defaultSound.destory();
            defaultSound = null;
        }
        
        /**
        *   生成并直接激活声音动画
        */ 
        public static function generateAndActiveSoundMovie(name:String, preSuffix:String = AUDIO_SUFFIX):GMovieClip
        {
            // 根据前缀的优先级来组织前缀数组，优先传入的参数
            var suffixList:Array = [AUDIO_SUFFIX, MUSIC_SUFFIX];
            var index:int;
            if ((index = suffixList.indexOf(preSuffix)) == -1)
                suffixList[suffixList.length] = preSuffix;
            else if (index == 1)
                suffixList = suffixList.reverse();
            
            var length:int = suffixList.length;
            for (var i:int = 0; i < length; ++i)
            {
                var suffixName:String = suffixList[i];
                var soundMovie:GMovieClip = generateSoundMovie(name, suffixName);
                if (soundMovie)
                {
                    SoundManager.instance.activeSoundSprite((suffixName == AUDIO_SUFFIX ? SoundManager.AUDIO : SoundManager.MUSIC), soundMovie);
                    return soundMovie;
                }
            }
            
            return null;
        }
        
        public static function generateSoundClass(name:String, preSuffix:String = AUDIO_SUFFIX):Class
        {
            if (!name)
                return null;
            
            var soundName:String = [preSuffix, name].join("");
            var resourceClass:Class = null;
            try
            {
                resourceClass = getDefinitionByName(soundName) as Class;
            }
            catch (e:ReferenceError)
            {
            }
            
            return resourceClass;
        }
        
        /**
        *  生成声音资源
        */ 
        public static function generateSoundMovie(name:String, preSuffix:String = AUDIO_SUFFIX):GMovieClip
        {
            var resourceClass:Class = generateSoundClass(name, preSuffix);
            return resourceClass ? (new GMovieClip(resourceClass, true, true)) : null;
        }
        
        /**
        *  激活声音
        */ 
        public function activeSoundSprite(globalType:String, soundSprite:Sprite):void
        {
            addGlobalSound(globalType, soundSprite);
        }
        
        /**
        *  取消激活声音
        */ 
        public function disactiveSoundSprite(soundSprite:Sprite):void
        {
            removeGlobalSound(soundSprite);
        }
        
        /**
        *  添加声音到全局中
        */ 
        private function addGlobalSound(globalType:String, soundSprite:Sprite):void
        {
            if (!globalType || !soundSprite)
                return;
            
            var globalSprite:Sprite = _globalSounds[globalType];
            if (!globalSprite)
                globalSprite = _globalSounds[globalType] = new Sprite();

            if (soundSprite.parent != globalSprite)
                globalSprite.addChild(soundSprite);
        }
        
        /**
        *  从全局中移除声音
        */ 
        private function removeGlobalSound(soundSprite:Sprite):void
        {
            if (!soundSprite)
                return;
            
            soundSprite.soundTransform = new SoundTransform(0);
            if (soundSprite.parent)
                soundSprite.parent.removeChild(soundSprite);
        }
        
        /**
        *  设置全局音量
        */ 
        public function setGlobalVolumeByType(globalType:String, volume:Number, pan:Number = 0.0):void
        {
            var globalSprite:Sprite = _globalSounds[globalType];
            if (globalSprite)
                globalSprite.soundTransform = new SoundTransform(volume, pan);
        }
        
        /**
         * 设置声音的大小
         *  
         * @param name    名称
         * @param volume    声音
         * @param len    变化需要的时间
         */    
        public function setVolume(name:String, volume:Number,len:Number = 0):void
        {
            var sc:SoundChannel = getActiveChannel(name);
            if (sc)
            {
                if (len==0)
                    sc.soundTransform = new SoundTransform(volume);
                else
                    TweenUtil.to(sc,len,{volume:volume});
            }
        }
        
        /**
         * 设置声音位置
         * 
         * @param name    名称
         * @param pan    声音位置，范围由-1到1
         * @param len    过渡时间
         */
        public function setPan(name:String, pan:Number,len:Number):void
        {
            var sc:SoundChannel = getActiveChannel(name);
            if (sc)
            {
                if (len==0)
                    sc.soundTransform = new SoundTransform(sc.soundTransform.volume,pan);
                else
                    TweenUtil.to(sc,len,{pan:pan});
            }
        }
        
        /**
         * 声音是否正在播放
         *  
         * @param name    名称
         * 
         */    
        public function isPlaying(name:String):Boolean
        {
            return activeSound[transName(name)]!=null;
        }
        
        /**
         * 停止播放
         *  
         * @param name    名称
         * @param len    渐隐需要的时间
         */    
        public function stop(name:String,len:Number=0):void
        {
            name = transName(name);
            
            var sc:SoundChannel = activeSound[name];
            delete activeSound[name];
            
            if (sc)
            {
                if (len==0)
                    sc.stop();
                else    
                    TweenUtil.to(sc,len,{volume:0.0,onComplete:sc.stop});
            }
        }

        public function getActiveChannel(name:String):SoundChannel
        {
            return activeSound[transName(name)];
        }
        /**
         * 播放
         *  
         * @param name    名称
         * @param loop    循环次数，-1为无限循环
         * @param volume    声音
         * @param len    渐显需要的时间
         */        
        public function play(name:String, loop:int=1, volume:Number=-1,len:Number=0):void
        {
            name = transName(name);
            try
            {
                var ref:Class = getDefinitionByName(name) as Class;
                  var channel:SoundChannel = ((new ref()) as Sound).play(0, (loop != -1)?loop:int.MAX_VALUE);
                  
                if (channel)
                {
                    if (loop != 0 && loop != -1)
                        channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
                    
                    activeSound[name] = channel;
                    
                    if (len==0)
                    {
                        channel.soundTransform = new SoundTransform((volume != -1) ? volume : defaultVolume);
                    }
                    else
                    {
                        channel.soundTransform = new SoundTransform(0);
                        TweenUtil.to(channel,len,{volume:(volume != -1) ? volume : defaultVolume}) 
                    }
                }
            }
            catch(e:Error)
            {
            }    
        }
         

        private function soundCompleteListener(evt:Event):void
        {
            evt.currentTarget.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
            
            for (var key:* in activeSound)
            {
                if (activeSound[key] == evt.currentTarget)
                {
                    delete activeSound[key];
                    return;
                }    
            }
            
        }
        
        private function transName(name:String):String
        {
            if (basePath == "" || name.indexOf(".")!= -1)
                return name;
            else
                return basePath + "." + name;
        }
    }
}