package centaur.display.ui.combat.handler.types
{
	import centaur.data.GlobalAPI;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillDataList;
	import centaur.display.ui.combat.CombatActPanel;
	import centaur.display.ui.combat.CombatPanel;
	import centaur.display.ui.combat.handler.ActionHandler;
	import centaur.effects.CombatActionEffect;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.SkillStartAction;
	import centaur.utils.UniqueNameFactory;
	
	import flash.display.Sprite;

	/**
	 *   处理技能开始时的操作
	 *   @author wangq 2013.04.12
	 */ 
	public final class SkillStartHandler extends ActionHandler
	{
		public function SkillStartHandler(action:ActionBase)
		{
			super(action);
		}
		
		override public function doHandler():void
		{
			var actionData:SkillStartAction = action as SkillStartAction;
			if (!actionData)
				return;
			
			var selfCardObj:BaseCardObj = UniqueNameFactory.UniqueObjDic[actionData.srcObj];
			if (!selfCardObj)
				return;
			
			// 释放技能时，处理回合行动效果
			if (selfCardObj.render)
			{
				var offsetY:Number = CombatPanel.instance.isSelfCard(selfCardObj) ? -5 : 5;
				CombatActionEffect.addActionEffect(selfCardObj.render, offsetY);
			}
			
			// 处理技能效果
			var targetList:Array = actionData.targets;
			var len:int = targetList ? targetList.length : 0;
			if (len > 0)
			{
				for (var i:int = 0; i < len; ++i)
				{
					var cardObj:BaseCardObj = UniqueNameFactory.UniqueObjDic[targetList[i]];
					if (cardObj)
						handleEffect(actionData.skillID, cardObj);
				}
			}
			else
			{
				var target:* = UniqueNameFactory.UniqueObjDic[actionData.targetObj];
				handleEffect(actionData.skillID, target);
			}
		}
		
		/**
		 *   技能效果只对卡牌，不对角色
		 */ 
		private function handleEffect(skillID:uint, target:BaseCardObj):void
		{
			if (!target)
				return;
			
			var skillData:SkillData = SkillDataList.getSkillData(skillID);
			if (!skillData)
				return;
			
			var parentObj:Sprite = target.render;
			if (skillData)
				GlobalAPI.effectManager.renderEffectByPath(skillData.effectPath, parentObj);
		}
	}
}