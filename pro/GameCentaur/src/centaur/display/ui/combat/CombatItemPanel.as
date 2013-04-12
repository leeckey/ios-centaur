package centaur.display.ui.combat
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.Sprite;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;

	public final class CombatItemPanel extends GBuilderBase
	{
		public var combatItem1:GBase;
		public var combatItem2:GBase;
		public var combatItem3:GBase;
		public var combatItem4:GBase;
		public var combatItem5:GBase;
		public var combatItemList:Array;
		public var combatCardList:Array;
		
		public function CombatItemPanel(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
			setup();
		}
		
		protected function setup():void
		{
			combatCardList = [];
			combatItemList = [combatItem1, combatItem2, combatItem3, combatItem4, combatItem5];
		}
		
		public function addCardToCombatArea(cardObj:BaseCardObj):void
		{
			var idx:int = -1;
			if ((idx = combatCardList.indexOf(cardObj)) == -1)
			{
				combatCardList.push(cardObj);
				idx = combatCardList.length - 1;
			}
			cardObj.updateRender(BaseCardObj.SKIN_NORMAL_TYPE);
			var parentContent:Sprite = combatItemList[idx] as Sprite;
			if (cardObj.render && parentContent)
				parentContent.addChild(cardObj.render);
		}
		
		public function removeCardFromCombatArea(cardObj:BaseCardObj):void
		{
			if (!cardObj)
				return;
			
			var idx:int = combatCardList.indexOf(cardObj);
			if (idx < 0)
				return;
			
			combatCardList.splice(idx, 1);
			if (cardObj.render && cardObj.render.parent)
				cardObj.render.parent.removeChild(cardObj.render);
		}
	}
}