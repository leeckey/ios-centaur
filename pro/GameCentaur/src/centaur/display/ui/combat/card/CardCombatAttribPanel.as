package centaur.display.ui.combat.card
{
	import ghostcat.ui.controls.GBuilderBase;
	import ghostcat.ui.controls.GText;

	/**
	 *   卡牌的战斗区时的属性面板
	 */ 
	public final class CardCombatAttribPanel extends GBuilderBase
	{
		public var attackText:GText;
		public var hpText:GText;
		
		public function CardCombatAttribPanel()
		{
			super("");
		}
	}
}