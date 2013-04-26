package centaur.display.ui.combat
{
	import centaur.display.control.GCProgressBar;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.controls.GBuilderBase;

	/**
	 *   角色的战斗面板，战斗时分己方和敌方
	 */ 
	public final class CombatActPanel extends GBuilderBase
	{
		public var actHPBar:GCProgressBar;				// 角色血条
		public var waitItemPanel:WaitItemPanel;			// 等待区
		public var combatItemPanel:CombatItemPanel;		// 战斗区
		public var cemeteryItemPanel:CemeteryItemPanel;	// 墓地区
		public var cemeteryItemSample:GBase;			// 墓地区样式位置
		
		private var _actObj:BaseActObj;					// 面板对应Act数据
		
		public function CombatActPanel(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
			setup();
		}
		
		protected function setup():void
		{
			cemeteryItemPanel = new CemeteryItemPanel(cemeteryItemSample);
		}
		
		override public function set data(v:*):void
		{
			if (super.data != v)
			{
				_actObj = v as BaseActObj;
				super.data = v;
				
				onData();
			}
		}
		
		private function onData():void
		{
			if (_actObj && _actObj.actData)
			{
				// 初始化战斗数据
				_actObj.resetCombatData();
				
				// 更新血条显示
				actHPBar.setMaxValue(_actObj.actData.maxHP);
				actHPBar.setCurrValue(_actObj.actData.maxHP);
			}
		}
		
		public function onActDamageNotify(damage:int):void
		{
			if (_actObj)
			{
				// 角色受伤害，处理血量变更
				_actObj.deductHp(damage, false);
				actHPBar.setCurrValue(_actObj.hp);
			}
		}
		
		public function addCardToWaitArea(cardObj:BaseCardObj):void
		{
			if (!cardObj)
				return;
			
			combatItemPanel.removeCardFromCombatArea(cardObj);
			cemeteryItemPanel.removeCardToCemeteryArea(cardObj);
			
			if (waitItemPanel)
				waitItemPanel.addCardToWaitArea(cardObj);
		}
		
		public function addCardToCombatArea(cardObj:BaseCardObj):void
		{
			if (!cardObj || !waitItemPanel || !combatItemPanel)
				return;
			
			cemeteryItemPanel.removeCardToCemeteryArea(cardObj);
			waitItemPanel.removeCardFromWaitArea(cardObj);
			
			// 更新卡牌的显示内容和位置
			combatItemPanel.addCardToCombatArea(cardObj);
		}
		
		public function addCardToCemeteryArea(cardObj:BaseCardObj):void
		{
			if (!cardObj || !cemeteryItemSample)
				return;
			
			if (waitItemPanel)
				waitItemPanel.removeCardFromWaitArea(cardObj);
			if (combatItemPanel)
				combatItemPanel.removeCardFromCombatArea(cardObj);
			
			// 添加到墓地
			cemeteryItemPanel.addCardToCemeteryArea(cardObj);
		}
		
		public function onRoundEnd():void
		{
			// 回合结束时刷新战斗区，左对齐
			if (combatItemPanel)
				combatItemPanel.onRoundEnd();
			
			// 等待区左对齐,并且刷新等待回合数
			if (waitItemPanel)
				waitItemPanel.onRoundEnd();
		}
		
	}
}