package centaur.logic.skill
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;

	/**
	 *   所有技能处理的基类
	 */ 
	public class SkillHandlerBase
	{
		public function SkillHandlerBase()
		{
		}
		
		public function doHandler(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):*
		{
			return null;
		}
	}
}