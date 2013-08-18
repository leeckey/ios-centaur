package network
{
	import flash.net.NetworkInfo;
	

	public final class NetWorkInfoHelper
	{
		/**
		 *   获取硬件Mac地址
		 */ 
		public static function getHardwareAddress():String
		{
			return (NetworkInfo.isSupported) ? AndroidNetwork.getAddress() : IOSNetwork.getAddress();
		}
	}
}