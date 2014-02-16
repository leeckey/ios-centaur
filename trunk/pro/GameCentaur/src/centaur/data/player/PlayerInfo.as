package centaur.data.player
{
	import centaur.data.GlobalEventDispatcher;
	import centaur.utils.shareobject.PlayerInfoShareManager;
	
	import flash.events.Event;

	/**
	 *   角色信息类
	 */ 
	public final class PlayerInfo
	{
		public var id:uint;
		public var accountID:String;	// 可能用手机MAC地址
		public var name:String;
		public var sex:Boolean;	// true male  false female
		public var lv:int;
		public var uin:String;					// 唯一ID
		public var sKey:String;					// 登陆状态临时分配Key值
		public var icon:int;
		public var exp:uint;
		public var money:uint;
		public var diamond:uint;
		public var vigour:uint;
		public var lastUpdateTime:uint;
		
		public var heroHP:int;					// 英雄血量
		public var cost:int;					// 卡牌总cost值
		public var cardTeam:int;				// 当前卡组号
		public var totalAttack:int;				// 总攻击力
		public var totalBody:int;				// 体力
		public var maxBody:int;					// 最大体力
		public var mapEnableCount:int;			// 当前地图开启最大数量
		
		public var maxCombatCard:int;			// 最大上场卡牌数量
		public var insFinishList:Array;			// 记录主角通关的所有副本ID
		
		public function PlayerInfo()
		{
		}
		
		/**
		 *   {"Uin":"100001","NickName":"tyfeng","Sex":"1","Icon":"1","Money":"1000",
		 *    "Diamond":"0","Vigour":"100","Exp":"0","LastUpdateTime":"1378450313",
		 *    "result":0,"is_new":0} 
		 */ 
		public function loadData(data:Object):void
		{
			this.name = data.NickName;
			this.sex = data.Sex;
			this.icon = data.Icon;
			this.money = data.Money;
			this.diamond = data.Diamond;
			this.vigour = data.Vigour;
			this.exp = data.Exp;
			this.lastUpdateTime = data.LastUpdateTime;
		}
		
		public function calcInsStarLv(insIDList:Array):uint
		{
			var starLv:uint = 0;
			if (!insFinishList)
				return starLv;
			
			var len:int = insIDList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var insID:uint = insIDList[i];
				if (insFinishList.indexOf(insID) == -1)
					break;
			}
			
			starLv = i;
			if (starLv > 3) starLv = 3;
			return starLv;
		}
		
		public function flagInsIDFinish(insID:uint):Boolean
		{
			if (!insID)
				return false;
			
			if (!insFinishList)
				insFinishList = [];
			var idx:int = insFinishList.indexOf(insID);
			if (idx >= 0)
				return false;
			
			insFinishList.push(insID);
			insFinishList.sort(Array.NUMERIC);
			PlayerInfoShareManager.saveSelf();	// 保存自己数据到本地
			GlobalEventDispatcher.dispatch(new Event(GlobalEventDispatcher.INS_COMBAT_COMPLETE), insID);
			
			return true;
		}
		
		public function flagMapIDFinish(mapID:uint):Boolean
		{
			if (this.mapEnableCount != mapID)
				return false;
			
			this.mapEnableCount = ++mapID;
			PlayerInfoShareManager.saveSelf();	// 保存自己数据到本地
			GlobalEventDispatcher.dispatch(new Event(GlobalEventDispatcher.MAP_COMBAT_COMPLETE), mapID);
			
			return true;
		}
	}
}