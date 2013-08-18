package network
{
	import com.adobe.nativeExtensions.Networkinfo.NetworkInfo;
	import com.adobe.nativeExtensions.Networkinfo.NetworkInterface;

	public final class IOSNetwork
	{
		public static function getAddress():String
		{
			var address:String;
			var info:NetworkInfo = NetworkInfo.networkInfo;
			var interfaces:Vector.<NetworkInterface> = info.findInterfaces();
			if (interfaces.length > 0)
				address = interfaces[0].hardwareAddress;
			return address;
		}
	}
}