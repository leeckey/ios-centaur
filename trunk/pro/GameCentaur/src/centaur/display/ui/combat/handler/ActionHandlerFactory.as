package centaur.display.ui.combat.handler
{
	import centaur.display.ui.combat.handler.types.AttackChangeHandler;
	import centaur.display.ui.combat.handler.types.AttackEffectHandler;
	import centaur.display.ui.combat.handler.types.CardToCemeteryAreaHandler;
	import centaur.display.ui.combat.handler.types.CardToCombatAreaHandler;
	import centaur.display.ui.combat.handler.types.CardToWaitAreaHandler;
	import centaur.display.ui.combat.handler.types.CureNotifyHandler;
	import centaur.display.ui.combat.handler.types.DamageNotifyHandler;
	import centaur.display.ui.combat.handler.types.RoundEndHandler;
	import centaur.display.ui.combat.handler.types.RoundStartHandler;
	import centaur.display.ui.combat.handler.types.SkillEndHandler;
	import centaur.display.ui.combat.handler.types.SkillStartHandler;
	import centaur.logic.action.ActionBase;
	import centaur.logic.action.RoundStartAction;
	import centaur.logic.combat.CombatLogic;
	
	import flash.utils.Dictionary;

	/**
	 *   各种战斗行为的工厂类，负责初始化对应行为操作
	 */ 
	public final class ActionHandlerFactory
	{
		private static var _actionDic:Dictionary = new Dictionary();
		_actionDic[ActionBase.ACTION_SELECT_TO_WAITAREA] = new CardToWaitAreaHandler(null);
		_actionDic[ActionBase.ACTION_SELECT_TO_COMBATAREA] = new CardToCombatAreaHandler(null);
		_actionDic[ActionBase.ACTION_SELECT_TO_CEMETERYAREA] = new CardToCemeteryAreaHandler(null);
		_actionDic[ActionBase.ACTION_ROUND_START] = new RoundStartHandler(null);
		_actionDic[ActionBase.ACTION_ROUND_END] = new RoundEndHandler(null);
		_actionDic[ActionBase.ACTION_DAMAGE_NOTIFY] = new DamageNotifyHandler(null);
		_actionDic[ActionBase.ACTION_ATTACK_EFFECT] = new AttackEffectHandler(null);
		_actionDic[ActionBase.ACTION_SKILL_START] = new SkillStartHandler(null);
		_actionDic[ActionBase.ACTION_SKILL_END] = new SkillEndHandler(null);
		_actionDic[ActionBase.ACTION_CURE_NOTIFY] = new CureNotifyHandler(null);
		_actionDic[ActionBase.ACTION_ATTACK_CHANGE] = new AttackChangeHandler(null);
		
		public static function getInstance(actionBase:ActionBase):ActionHandler
		{
			var action:ActionHandler = _actionDic[actionBase.type];
			if (action)
			{
				action.data = actionBase;
				return action;
			}
			
			return new ActionHandler(actionBase);
		}
	}
}