package
{
	

	public class IOSMain extends GameMain
	{
		public function IOSMain()
		{
			super();
		}
		
//		override protected function setup():void
//		{
//			//开启多点触控
//			Starling.multitouchEnabled = true;
//			
//			//在iOS上不用开启，节约大量内存
//			Starling.handleLostContext = false; 
//			
//			//当Stage3D层初始化，屏幕会很黑屏
//			//为了解决这个问题，我们可以当程序启动时采取展示一张图片，然后当Straling开始工作移除它，。
//			//因为我们不需要添加,Default.png之类的
//			addSetupLoading();
//			
//			autoSize();
//			
//			initEvents();
//		}
//		
//		override protected function autoSize():void
//		{
//			//在iPhone中能铺满屏幕;iPad中则两边会有很块，因为它们的宽高比不一样。
//			var screenWidth:int  = stage.fullScreenWidth;
//			var screenHeight:int = stage.fullScreenHeight;
//			var viewPort:Rectangle = new Rectangle();
//			
//			if (screenHeight / screenWidth < GameConstant.ASPECT_RATIO)
//			{
//				viewPort.height = screenHeight;
//				viewPort.width  = int(viewPort.height / GameConstant.ASPECT_RATIO);
//				viewPort.x = int((screenWidth - viewPort.width) / 2);
//			}
//			else
//			{
//				viewPort.width = screenWidth; 
//				viewPort.height = int(viewPort.width * GameConstant.ASPECT_RATIO);
//				viewPort.y = int((screenHeight - viewPort.height) / 2);
//			}
//			
//			GlobalData.starling = new Starling(GameBase, stage, viewPort, null, "auto", "baseline");
//		}
//		
//		private function addSetupLoading():void
//		{
//			
//		}
	}
}