package centaur.display.ui.login
{
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	
	import mx.core.Application;

	public final class LoginPanel extends GBuilderBase
	{
		public var loginBtn:GButton;
		
		public function LoginPanel()
		{
			super(LoginAsset);
			
			loginBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			trace("a");
		}
	}
}