package centaur.logic.combat
{
	import centaur.data.combat.CombatData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.NormalAttackAction;
	import centaur.logic.action.SelectCardToCombatAreaAction;
	import centaur.logic.action.SelectCardToWaitAreaAction;
	
	import flashx.textLayout.elements.BreakElement;

	/**
	 *   战斗的逻辑计算对象
	 */ 
	public class CombatLogicObj
	{
		public var selfAct:BaseActObj;			// 攻击者
		public var targetAct:BaseActObj;		// 受攻击者
		public var selfCombatData:CombatData;
		
		public function CombatLogicObj(selfAct:BaseActObj, targetAct:BaseActObj)
		{
			this.selfAct = selfAct;
			this.targetAct = targetAct;
			
			init();
		}
		
		protected function init():void
		{
			if (!selfAct)
				return;
			
			// 初始化自身的战斗区数据
			selfAct.resetCombatData();
			selfCombatData = selfAct.combatData;
		}
		
		/**
		 *   阶段前的全局技能,返回对应的操作数据
		 */ 
		public function preSkill(list:Array):Object
		{
			if (!selfAct)
				return null;
			
			return null;	
		}
		
		/**
		 *  从卡堆随机一张到等待区域
		 */ 
		public function selectCardToWaitArea(list:Array):Object
		{
			if (!selfAct)
				return null;
			
			// 随机从卡堆挑选一个进入等待区域
			var len:int = selfCombatData.selfCardArea.length;
			var ranIdx:int = len * Math.random();
			var cardObj:BaseCardObj = selfCombatData.selfCardArea[ranIdx];
			selfCombatData.selfCardArea.splice(ranIdx, 1);
			selfCombatData.selfWaitArea.push(cardObj);
			selfCombatData.selfWaitArea.sortOn("waitRound", Array.NUMERIC);
			
			// 添加相应操作
			var action:SelectCardToWaitAreaAction = new SelectCardToWaitAreaAction();
			action.srcObj = selfAct.objID;
			action.targetObj = targetAct.objID;
			action.cardID = cardObj.objID;
			list.push(action);
			
			return null;
		}
		
		/**
		 *  从等待区选择无需等待卡到战斗区域
		 */ 
		public function selectCardToCombatArea(list:Array):Object
		{
			if (!selfAct)
				return null;
			
			var len:int = selfCombatData.selfWaitArea.length;
			while (selfCombatData.selfWaitArea.length > 0)
			{
				var cardObj:BaseCardObj = selfCombatData.selfWaitArea[0];
				if (cardObj.cardData.waitRound > 0)
					break;
				
				// 从等待队列挑选一个进入战斗区域
				selfCombatData.selfWaitArea.splice(0, 1);
				selfCombatData.selfCombatArea.push(cardObj);
				
				// 添加相应操作
				var action:SelectCardToCombatAreaAction = new SelectCardToCombatAreaAction();
				action.srcObj = selfAct.objID;
				action.targetObj = targetAct.objID;
				action.cardID = cardObj.objID;
				list.push(action);
			}
			
			return null;
		}
		
		public function doCombat(list:Array):Object
		{
			if (!selfAct)
				return null;
			
			var cardList:Array = selfCombatData.selfCombatArea;
			var len:int = cardList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var cardObj:BaseCardObj = selfCombatData.selfCombatArea[i];
				if (!cardObj)
					continue;
				
				var targetObj:BaseCardObj = targetAct.combatData.selfCombatArea[i];
				doCombatImpl(cardObj, targetObj, list);
			}
			
			return null;
			
		}
		
		private function doCombatImpl(srcObj:BaseCardObj, targetObj:BaseCardObj, list:Array):void
		{
			// 对位目标卡牌存在，攻击它，否则技能攻击位置0的卡，普通攻击血槽
			// 主动技能攻击,选择对位卡牌，没有则选择0位卡牌，再没有不释放
			var skillTargetObj:BaseCardObj = targetObj;
			if (!skillTargetObj)
				skillTargetObj = targetAct.combatData.selfCombatArea[0];
			if (skillTargetObj)
			{
			
				// 目标受技能攻击时被动技能的触发
				
				// 主动技能时影响到自身被动技能的触发
			}
			
			// 普通攻击
			var normalTargetObj:Object = targetObj;
			if (!normalTargetObj)
				normalTargetObj = targetAct;
			doNormalAttack(srcObj, normalTargetObj, list);
			
		}
		
		/**
		 *   技能攻击
		 */ 
		private function doSkillAttack(srcObj:BaseCardObj, targetObj:BaseCardObj, list:Array):void
		{
		}
		
		/**
		 *   普通攻击
		 */ 
		private function doNormalAttack(srcObj:BaseCardObj, normalTargetObj:Object, list:Array):void
		{
			if (normalTargetObj is BaseActObj)
			{
				// 攻击血槽
				var attackAction:NormalAttackAction = new NormalAttackAction();
				attackAction.damage = srcObj.cardData.attack;
				attackAction.srcObj = srcObj.objID;
				attackAction.targetObj = (normalTargetObj as BaseActObj).objID;
				
			}
			else
			{
				
			}
			
			// 目标受普通攻击时的被动技能的触发
			
			// 普通攻击时影响到自身被动技能的触发
			
		}
		
	}
}