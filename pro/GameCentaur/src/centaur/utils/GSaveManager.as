package centaur.utils
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	
	/**
	 * 本地保存数据管理器
	 * @author leo
	 * 
	 */	
	public class GSaveManager
	{
		private static var _instance :GSaveManager = null;
		
		private var sharedObj :SharedObject;
		public function GSaveManager(prv :PrivateClass)
		{
		}
		
		public static function get  instance():GSaveManager
		{
			if(_instance == null)
			{
				_instance = new GSaveManager(new PrivateClass());
			}
			return _instance;
		}
		/**
		 * 保存玩家数据 
		 * @param playerData
		 * 
		 */		
		public function savePlayerData(playerData:Array):void
		{
			setData(playerData,"settingData");
			_pd = playerData;
			trace("保存用户数据");
		}
		/**
		 * 获取玩家数据 
		 * @param name
		 * @return 
		 * 
		 */		
		
		private var _pd:Array = null;
		/*public function getPlayerData(name :String = "settingData"):Array
		{
			if(!_pd)
			{
				var obj :Object = getData(name);
				_pd = obj as Array;
			}
			//进行数据检测
			if(_pd && (_pd[SettingEnum.VOICEEFFECT] == null || _pd[SettingEnum.Chang_Weapon] == null ||　_pd[SettingEnum.VoiceOnOff] == null))
			{
				savePlayerData(SettingEnum.defaultInfo);
			}
			return _pd;
		}*/
		
		
		/**
		 * 保存数据
		 * @param obj
		 * @param objName 
		 * @param defName
		 * 
		 */		
		public function setData(obj :Object,objName :String,defName :String= "localSharedObj"):void
		{
			this.sharedObj = SharedObject.getLocal(defName,"/");
			this.sharedObj.data[objName] = obj;
			try
			{
				this.sharedObj.flush(1000);
				this.sharedObj.addEventListener(NetStatusEvent.NET_STATUS,netHandler);
			}catch(e :Error)
			{
				trace(e.message);
			}
		}
		/**
		 * 获取数据
		 * @param objName  单个属性值
		 * @param defName
		 * @return 
		 * 
		 */		
		public function getData(objName :String,defName :String= "localSharedObj"):Object
		{
			this.sharedObj = SharedObject.getLocal(defName,"/");
			if(this.sharedObj.data[objName] != null)
			{
				return this.sharedObj.data[objName];
			}
			
			return null;
		}
		
		public function clear(defName:String = "localSharedObj"):void
		{
			this.sharedObj = SharedObject.getLocal(defName,"/");
			if (sharedObj)
				sharedObj.clear();
		}
		
		private function netHandler(e :NetStatusEvent):void
		{
			switch(e.info.code)
			{
				case "SharedObject.Flush.Failed":
					trace("存储失败");
					break;
				case "SharedObject.Flush.Success":
					trace("存储成功");
					break;
			}
			this.sharedObj.removeEventListener(NetStatusEvent.NET_STATUS,netHandler);
		}
		
	}
}
class PrivateClass{}