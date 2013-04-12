package centaur.data
{
	public final class GameConstant
	{
		//选择这样的size主要是为了适应大多数的手机设备，这个分辨能在iPhone的效果几乎完美，没有黑色边块。
		//如果我们使用横版模式，那我们就需要交换宽高的值
		
		public static const STAGE_WIDTH:int  = 960;
		public static const STAGE_HEIGHT:int = 640;
		
		public static const ASPECT_RATIO:Number = STAGE_HEIGHT / STAGE_WIDTH;
	}
}