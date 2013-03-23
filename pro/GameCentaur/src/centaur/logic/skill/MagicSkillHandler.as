package centaur.logic.skill
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.SkillEffectAction;

	/**
	 *   魔法技能攻击基类
	 */
	public class MagicSkillHandler extends SkillHandlerBase
	{
		public function MagicSkillHandler()
		{
			super();
		}
		
		override public function doHandler(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):*
		{
			// 没有目标，不释放技能
			var targetList:Array = SkillLogic.getTargetList(skillData, srcObj, srcObj.owner, targetObj);
			var targetLen:int;
			if (!targetList || (targetLen = targetList.length) == 0)
				return;
			
			// 增加释放技能操作
			list.push(SkillEffectAction.addSkillEffect(srcObj.objID, 0, skillData.templateID, targetList));
			
			// 对每个目标处理被技能攻击的回调
			for (var i:int = 0; i < targetLen; ++i)
			{
				var targetCardObj:BaseCardObj = targetList[i];
				if (targetCardObj)
					targetCardObj.onSkilled(skillData, srcObj, list);
			}
			
			return null;
		}
	}
}