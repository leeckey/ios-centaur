package centaur.display.ui.combat
{
	import centaur.logic.act.BaseCardObj;
	
	import flash.display.Sprite;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;

	/**
	 *   战斗区面板
	 *   @author wangq 2013.04.13
	 */ 
	public final class CombatItemPanel extends GBuilderBase
	{
		public var combatItem1:GBase;			// 战斗区的战斗格子
		public var combatItem2:GBase;
		public var combatItem3:GBase;
		public var combatItem4:GBase;
		public var combatItem5:GBase;
		public var combatItemList:Array;		// 战斗区格子列表
		public var combatCardList:Array;		// 战斗区卡牌数据
		
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
		
		public function onRoundEnd():void
		{
			updateCombatList();
		}
		
		/**
		 *   刷新战斗区列表，全部左对齐
		 */ 
		private function updateCombatList():void
		{
			var len:int = combatCardList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var cardObj:BaseCardObj = combatCardList[i];
				if (!cardObj)
					continue;
				
				var parentContent:Sprite = combatItemList[i] as Sprite;
				if (cardObj.render && parentContent && parentContent != cardObj.render.parent)
					parentContent.addChild(cardObj.render);
			}
		}
	}
}