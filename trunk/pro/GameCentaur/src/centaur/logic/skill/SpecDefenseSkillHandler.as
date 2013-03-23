package centaur.logic.skill
{
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;

	/**
	 *   特殊技能防御基类
	 */
	public class SpecDefenseSkillHandler extends SkillHandlerBase
	{
		public function SpecDefenseSkillHandler()
		{
			super();
		}
		
		override public function doHandler(skillData:SkillData, srcObj:BaseCardObj, targetObj:BaseActObj, list:Array, specifics:* = null):*
		{
			
			
			return null;
		}
	}
}