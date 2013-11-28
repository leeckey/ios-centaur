package centaur.logic.skills
{
	import centaur.data.buff.*;
	import centaur.data.skill.SkillData;
	import centaur.logic.act.BaseCardObj;
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * 冰弹：使一张或者多张卡牌受到100点伤害，30%概率下一回合无法行动 
	 * 闪电, 阻击也共用这个脚本
	 * @author liq
	 * 
	 */	
	public class Skill_100 extends BaseSkill
	{		
		/**
		 * 伤害值 
		 */		
		public var damage:int;
		
		/**
		 * buff触发概率 
		 */		
		public var rate:Number;
		
		private var buff:Class;
		
		public function Skill_100(data:SkillData, card:BaseCardObj, skillPara:Array)
		{
			super(data, card, skillPara);
		}
		
		/**
		 * 设置卡牌参数 
		 * @param data
		 * 
		 */		
		public override function initConfig(data:SkillData):void
		{
			// 设置公共信息
			super.initConfig(data);
			
			damage = data.param1 * skillLevel;
			rate = data.param2 / 100;
			if (data.buffID != 0)
			{
				buffID = data.buffID;
				buff = getDefinitionByName("centaur.logic.buff.Buff_" + BuffDataList.getBuffData(buffID).templateID) as Class;
			}
		}
				
		protected override function _doSkill(targetCard:BaseCardObj):void
		{
			if (targetCard == null)
				return;

			var hurt:int = targetCard.onSkillHurt(this, damage);
			if (hurt >= 0 && buffID > 0 && !targetCard.isDead && Math.random() < rate)
			{
				var data:BuffData = BuffDataList.getBuffData(buffID);
				data.level = skillLevel;
				new buff(targetCard, data);
			}
		}

	}
}