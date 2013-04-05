package centaur.logic.combat
{
	import centaur.data.buff.BuffData;
	import centaur.data.skill.SkillData;
	import centaur.data.skill.SkillDataList;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.AttackEffectAction;
	import centaur.logic.action.BuffNotifyAction;
	import centaur.logic.action.DamageNotifyAction;
	
	import flash.utils.Dictionary;

	/**
	 *   BUFF相关逻辑
	 */ 
	public final class BuffLogic
	{
		public static function doBuffer(srcObj:BaseCardObj, buffType:int, list:Array):Boolean
		{
			if (!srcObj || !srcObj.buffDic)
				return false;
			
			var buffTypeDic:Dictionary = srcObj.buffDic[buffType];
			if (!buffTypeDic)
				return false;
			
			var skipCurrentAction:Boolean = false;
			for each (var buffData:BuffData in buffTypeDic)
			{
				if (!buffData)
					continue;
				
				var buffSkill:SkillData = SkillDataList.getSkillTemplateData(buffData.skillID);
				if (!buffSkill)
					continue;
				
				// 持续伤害,负数表示加血
				if (buffSkill.durationDamage != 0)
				{
					var damage:int = srcObj.hp < buffSkill.durationDamage ? srcObj.hp : buffSkill.durationDamage;
					srcObj.deductHP(damage);
					list.push(DamageNotifyAction.getAction(damage, srcObj.objID));
					list.push(BuffNotifyAction.getAction(buffData, srcObj.objID, BuffNotifyAction.BUFF_REMOE_ACTION));
				}
				if (buffSkill.avoidBuffTypeRatio > 0 &&
					(Math.random() * 100 <= buffSkill.avoidBuffTypeRatio))
					skipCurrentAction = true;
				
				// BUFF结束
				buffSkill.durationRound--;
				if (buffSkill.durationRound <= 0)
					buffTypeDic[buffData.skillID] = null;
			}
			
			return skipCurrentAction;
		}
	}
}