package centaur.interfaces
{
	import centaur.interfaces.dispose.IDispose;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.geom.Transform;

	public interface IDisplayObject extends IEventDispatcher, IDispose
	{
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
		function get filters():Array;
		function set filters(value:Array):void;
		function get blendMode():String;
		function set blendMode(value:String):void;
		function get parent():DisplayObjectContainer;
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		function get transform():Transform;
		function set transform(value:Transform):void;
		function get alpha():Number;
		function set alpha(value:Number):void;
		function get rotation():Number;
		function set rotation(value:Number):void;
	}
}