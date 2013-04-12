package centaur.display.ui.combat.handler.types
{
	import centaur.data.GlobalAPI;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillDataList;
	import centaur.display.ui.combat.CombatActPanel;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.AttackEffectAction;
	import centaur.utils.UniqueNameFactory;
	
	import flash.display.Sprite;

	/**
	 *   处理普通攻击效果的操作
	 */ 
	public final class AttackEffectHandler extends ActionHandler
	{
		public function AttackEffectHandler(action:ActionBase)
		{
			super(action);
		}
		
		/**
		 *   处理普通攻击效果
		 *   @author wangq 2013.04.12
		 */ 
		override public function doHandler():void
		{
			var actionData:AttackEffectAction = action as AttackEffectAction;
			if (!actionData)
				return;
			
			////----wangq 定好格式后再写
//			var targetList:Array = actionData.targetList;
//			var len:int = targetList ? targetList.length : 0;
//			if (len > 0)
//			{
//				for (var i:int = 0; i < len; ++i)
//				{
//					var cardObj:BaseCardObj = UniqueNameFactory.UniqueObjDic[targetList[i]];
//					if (cardObj)
//						handleEffect(actionData.atkSkillID, cardObj);
//				}
//			}
//			else
//			{
//				var target:* = UniqueNameFactory.UniqueObjDic[actionData.targetObj];
//				handleEffect(actionData.atkSkillID, target);
//			}
		}
		
		private function handleEffect(skillID:uint, target:*):void
		{
			if (!target)
				return;
			
			var skillData:SkillData = SkillDataList.getSkillTemplateData(skillID);
			if (!skillData)
				skillData = null;	// 默认普通攻击
			
			var parentObj:Sprite;
			if (target is BaseCardObj)
				parentObj = (target as BaseCardObj).render;
			else if (target is BaseActObj)
			{
				// 血条掉血，parentObj为血条
				var actPanel:CombatActPanel = CombatPanel.instance.getActPanelByID((target as BaseActObj).objID);
				if (actPanel)
					parentObj = actPanel.actHPBar;
			}
			
			if (skillData)
				GlobalAPI.effectManager.renderEffectByPath(skillData.effectPath, parentObj);
		}
	}
}