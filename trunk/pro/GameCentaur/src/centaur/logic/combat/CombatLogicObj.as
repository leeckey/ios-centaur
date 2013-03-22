package centaur.logic.combat
{
	import centaur.data.combat.CombatData;
	import centaur.logic.act.BaseActObj;
	import centaur.logic.act.BaseCardObj;
	import centaur.logic.action.AttackEffectAction;
	import centaur.logic.action.SelectCardToCemeteryArea;
	import centaur.logic.action.SelectCardToCombatAreaAction;
	import centaur.logic.action.SelectCardToWaitAreaAction;
	import centaur.logic.action.SkillEffectAction;
	
	import flashx.textLayout.elements.BreakElement;

	/**
	 *   战斗的逻辑计算对象
	 */ 
	public class CombatLogicObj
	{
		public var selfAct:BaseActObj;			// 攻击者
		public var targetAct:BaseActObj;		// 受攻击者
		public var selfCombatData:CombatData;
		
		public var isWin:Boolean = false;
		
		public function CombatLogicObj(selfAct:BaseActObj, targetAct:BaseActObj)
		{
			this.selfAct = selfAct;
			selfAct.enemyActObj = this.targetAct = targetAct;
			
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
		
		public function checkIsWin():Boolean
		{
			// 参数标记赢，直接判定赢
			if (isWin)
				return true;
			
			if (!targetAct)
				return true;
			
			// 目标生命为0，或者战斗区内没有卡牌，则判定自身赢
			var targetCtData:CombatData = targetAct.combatData;
			if (targetAct.actData.hp <= 0 || 
				(targetCtData.selfCombatArea.length == 0 && targetCtData.selfCardArea.length == 0 && targetCtData.selfWaitArea.length == 0))
				return true;
			
			return false;
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
			if (len <= 0)
				return null;
			
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
				
				// 处理卡牌降临时
				cardObj.onPresent();
			}
			
			return null;
		}
		
		/**
		 *   卡牌移动到墓地区
		 */ 
		public function cardToCemeteryArea(ownerAct:BaseActObj, cardObj:BaseCardObj, list:Array):void
		{
			if (!ownerAct || !cardObj)
				return;
			
			var combatData:CombatData = ownerAct.combatData;
			// 从战斗区移除
			var idx:int = combatData.selfCombatArea.indexOf(cardObj);
			if (idx > -1)
				combatData.selfCombatArea[idx] = null;	// 位置不变，回合结束后梳理
			
			// 添加到墓地区
			if (combatData.selfCemeteryArea.indexOf(cardObj) == -1)
				combatData.selfCemeteryArea.push(cardObj);
			
			// 添加相应操作数据
			var action:SelectCardToCemeteryArea = new SelectCardToCemeteryArea();
			action.ownerID = ownerAct.objID;
			action.targetObj = cardObj.objID;
			list.push(action);
		}
		
		public function doCombat(list:Array):Boolean
		{
			if (!selfAct)
				return false;
			
			var cardList:Array = selfCombatData.selfCombatArea;
			var len:int = cardList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var cardObj:BaseCardObj = selfCombatData.selfCombatArea[i];
				if (!cardObj)
					continue;
				
				if (cardObj.checkDead())
					continue;
				
				if (cardObj.onRoundStart())
					continue;
				
				if (cardObj.onSkiller(targetAct, list))
					continue;
				
				if (cardObj.onAttacker(targetAct, list))
					continue;
				
				// 检测下对方英雄血条，因为普通攻击涉及到血条变更
				if (targetAct.actData.hp <= 0)
					return true;
				
				cardObj.onRoundEnd();
			}
			
			return false;
		}
		
		/**
		 *   整个回合结束阶段的处理
		 */ 
		public function roundEndCallback():void
		{
			// 等待区等待回合-1
			var len:int = selfCombatData.selfWaitArea.length;
			for (var i:int = 0; i < len; ++i)
			{
				var cardObj:BaseCardObj = selfCombatData.selfWaitArea[i];
				cardObj.cardData.waitRound--;
				if (cardObj.cardData.waitRound < 0)
					cardObj.cardData.waitRound = 0;
			}
			
			// 自身战斗区卡牌的顺序更新
			len = selfCombatData.selfCombatArea.length;
			for (i = len - 1; i >= 0; --i)
			{
				if (!selfCombatData.selfCombatArea[i])
					selfCombatData.selfCombatArea.splice(i, 1);
			}
		}
		
	}
}