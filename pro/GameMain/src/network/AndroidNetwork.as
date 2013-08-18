package network
{
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;

	public final class AndroidNetwork
	{
		public static function getAddress():String
		{
			var address:String;
			if (NetworkInfo.isSupported)
			{
				var info:NetworkInfo = NetworkInfo.networkInfo;
				var interfaces:Vector.<NetworkInterface> = info.findInterfaces();
				if (interfaces.length > 0)
					address = interfaces[0].hardwareAddress;
			}
			return address;
		}
	}
}