package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.CombatActPanel;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.effects.NumberEffect;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.DamageNotifyAction;
	import centaur.utils.NumberType;
	import centaur.utils.UniqueNameFactory;
	
	import flash.display.Sprite;

	/**
	 *   处理发生血量变更的操作
	 *   @author wangq 2013.04.12
	 */ 
	public final class DamageNotifyHandler extends ActionHandler
	{
		public function DamageNotifyHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:DamageNotifyAction = action as DamageNotifyAction;
			if (!actionData)
				return;
			
			var parentObj:Sprite;
			var damageObj:* = UniqueNameFactory.UniqueObjDic[actionData.targetObj];
			if (damageObj is BaseCardObj)
				parentObj = (damageObj as BaseCardObj).render;
			else if (damageObj is BaseActObj)
			{
				// 血条掉血，parentObj为血条
				var actPanel:CombatActPanel = CombatPanel.instance.getActPanelByID((damageObj as BaseActObj).objID);
				if (actPanel)
				{
					parentObj = actPanel.actHPBar;
					actPanel.onActDamageNotify(actionData.damage);
				}
			}
			
			new NumberEffect().addNumberEffect(actionData.damage, NumberType.PERSONCHOP, parentObj);
		}
	}
}