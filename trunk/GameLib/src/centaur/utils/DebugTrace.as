package centaur.utils
{
	import starling.display.Stage;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public final class DebugTrace
	{
		private static var _textField:TextField;
		
		public static function setup(stage:Stage):void
		{
			if (!stage)
				return;
			
			_textField = new TextField(100, 800, "");
			_textField.hAlign = HAlign.LEFT;
			_textField.vAlign = VAlign.TOP;
			_textField.x = stage.stageWidth - _textField.width;
			stage.addChild(_textField);
		}
		
		public static function debugTrace(msg:String):void
		{
			if (!_textField)
				return;
			
			if (_textField.textBounds.height > _textField.height * 0.8)
				_textField.text = "";
			_textField.text += msg + "\r\n";
		}
	}
}