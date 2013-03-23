package centaur.logic.skill
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.SkillEffectAction;

	/**
	 *   特殊技能攻击基类
	 */
	public class SpecSkillHandler extends SkillHandlerBase
	{
		public function SpecSkillHandler()
		{
			super();
		}
		
		override public function doHandler(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):*
		{
			var targetList:Array = SkillLogic.getTargetList(skillData, srcObj, srcObj.owner, targetObj);
			var targetLen:int;
			if (!targetList || (targetLen = targetList.length) == 0)
				return;
			
			// 增加释放技能操作
			list.push(SkillEffectAction.addSkillEffect(srcObj.objID, 0, skillData.templateID, targetList));
			
			// 死契或出场时,存在特殊技能,优先处理
			if (skillData.specialType > 0)
			{
				// 对每个目标处理特殊技能的回调
				for (var i:int = 0; i < targetLen; ++i)
				{
					var targetCardObj:BaseCardObj = targetList[i];
					if (targetCardObj)
						targetCardObj.onSpecSkilled(skillData, srcObj, list);
				}
			}
			
			// 对每个目标处理普通攻击技能的回调
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