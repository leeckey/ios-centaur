package centaur.display.ui.login
{
	import centaur.data.GlobalAPI;
	import centaur.data.GlobalData;
	import centaur.display.ui.mainui.MainPanel;
	
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	
	import gs.TweenLite;
	
	import mx.core.Application;
	
	import net.protocol.Net_LoginHandler;
	import net.protocol.Net_RegisterHandler;
	import net.protocol.Pck_GetPlayerInfo;
	import net.protocol.Pck_SetPlayerInfo;

	public final class LoginPanel extends GBuilderBase
	{
		public var clickScreenTxt:GBase;
		private var _alpha:Number = 1;
		
		private var _tween:TweenLite;
		
		public function LoginPanel()
		{
			 super(LoginAsset);
			
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			_tween = TweenLite.to(this, 1 * int.MAX_VALUE, {effectAlpha : int.MAX_VALUE});
		}
		
		override public function destory():void
		{
			this.removeEventListener(MouseEvent.CLICK, onMouseClick);
			TweenLite.removeTween(_tween);
			_tween = null;
			super.destory();
		}
		
		public function set effectAlpha(val:Number):void
		{
			_alpha = val;
			var intPart:int = int(_alpha);
			var floatPart:Number = _alpha - intPart;
			var isPart:Boolean = (intPart %2) == 1;
			
			var actualAlpha:Number = isPart ? (1 - floatPart) : (floatPart);
			if (clickScreenTxt)
				clickScreenTxt.alpha = actualAlpha;
		}
		
		public function get effectAlpha():Number
		{
			return _alpha;	
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			var address:String = GlobalData.macAddress;
			var request:Net_RegisterHandler = new Net_RegisterHandler(replyFunc);
			request.fastRegisterOrLogin(address);
			
			
		}
		
		private function replyFunc(data:Object):void
		{
			// {"result":0, "uin":1376912068, "skey":"@lJFqsKPoze6"}
			// {"result":-1, "info":"key params needed!"}
			
			if (!data || data.result < 0)
			{
				// 登陆失败，需要增加提示
				trace("登陆失败 " + data.info);
				return;
			}
			
			if (data.result == 0)
			{
				GlobalData.mainPlayerInfo.uin = data.uin;
				GlobalData.mainPlayerInfo.sKey = data.skey;
				
				var getInfo:Pck_GetPlayerInfo = new Pck_GetPlayerInfo(onGetPlayerInfo);
				getInfo.requestGetPlayerInfo(data.uin, data.skey);
			}
		}
		
		private function onGetPlayerInfo(data:Object):void
		{
			if (!data || data.result < 0)
			{
				// 获取角色信息失败，需要增加提示
				trace("获取角色信息失败 " + data.info);
				return;
			}
			
			if (data.result == 0)
			{
				// 创建角色新信息
				if (data.is_new != 0)
				{
					// 设置角色信息
					var setInfoPck:Pck_SetPlayerInfo = new Pck_SetPlayerInfo(onSetNewPlayerInfo);
					setInfoPck.requestSetPlayerInfo(GlobalData.mainPlayerInfo.uin, GlobalData.mainPlayerInfo.sKey, 
						"randomName" + int(Math.random() * 1000), 1, 1);
				}
				else
				{
					GlobalData.mainPlayerInfo.loadData(data);
					goToMainPanel();
				}
			}
		}
		
		/**
		 *  
		 */ 
		private function onSetNewPlayerInfo(data:Object):void
		{
			if (!data || data.result < 0)
			{
				// 设置角色信息失败，需要增加提示
				trace("设置角色信息失败 " + data.info);
				return;
			}
			
			if (data.result == 0)
			{
				var getInfo:Pck_GetPlayerInfo = new Pck_GetPlayerInfo(onGetPlayerInfo);
				getInfo.requestGetPlayerInfo(GlobalData.mainPlayerInfo.uin, GlobalData.mainPlayerInfo.sKey);
			}
		}
		
		private function goToMainPanel():void
		{
			// 跳转到主界面
			this.destory();
			if (!GlobalData.mainPanel)
				GlobalData.mainPanel = new MainPanel();
			GlobalAPI.layerManager.setModuleContent(GlobalData.mainPanel);
		}
	}
}