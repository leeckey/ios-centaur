package centaur.display.control
{
	import combat.FontSample1;
	
	import ghostcat.ui.controls.GText;

	public final class GTextField extends GText
	{
		public static const FONT_SAMPLE1 = FontSample1;
		
		
		public function GTextField(skin:* = null, replace:Boolean = true)
		{
			super(skin);
		}
	}
}