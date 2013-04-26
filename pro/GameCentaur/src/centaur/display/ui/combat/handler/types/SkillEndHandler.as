package centaur.display.ui.combat.handler.types
{
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.effects.CombatActionEffect;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.SkillEndAction;
	import centaur.utils.UniqueNameFactory;
	
	import flash.geom.Point;

	/**
	 *   处理技能结束时的操作
	 *   @author wangq 2013.04.12
	 */ 
	public final class SkillEndHandler extends ActionHandler
	{
		public function SkillEndHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:SkillEndAction = this.action as SkillEndAction;
			if (!actionData)
				return;
			
			var cardObj:BaseCardObj = UniqueNameFactory.UniqueObjDic[actionData.srcObj];
			if (!cardObj)
				return;
			
			// 技能结束，停止回合行动效果
			if (cardObj.render)
			{
				CombatActionEffect.removeActionEffect(cardObj.render);
			}
			
		}
	}
}