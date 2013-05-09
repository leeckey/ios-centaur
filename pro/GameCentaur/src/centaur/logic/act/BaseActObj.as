package centaur.logic.act
{
	import centaur.data.act.ActData;
	import centaur.data.card.CardData;
	import centaur.data.card.CardTemplateDataList;
	import centaur.data.combat.CombatData;
	import centaur.logic.action.*;
	import centaur.logic.combat.*;
	import centaur.logic.render.BaseActRender;
	import centaur.logic.skills.BaseSkill;
	import centaur.utils.UniqueNameFactory;

	/**
	 *  战斗目标的数据对象，类似于纯数据和显示对象的中间控制层
	 */ 
	public class BaseActObj
	{
		public var objID:uint;                   // 角色ID
		
		public var actData:ActData;              // 角色数据
		public var render:BaseActRender;         // 角色渲染控制
		public var cardObjList:Array;            // 角色卡牌

		public var scene:CombatScene;
		public var combatData:CombatData;        // 战斗数据区
		public var enemyActObj:BaseActObj;       // 对手
		
		public var hp:int;                       // 当前Hp
		public var isWin:Boolean = false;       // 是否胜利
		
		public function BaseActObj(data:ActData)
		{
			this.actData = data;
			objID = UniqueNameFactory.getUniqueID(this);
			
			init();
		}
		
		// 等待区最大数量
		private const MAX_WAIT_NUM:int = 5;

		/**
		 * 角色初始化 
		 * 
		 */		
		protected function init():void
		{
			if (!actData)
				return;
			
			cardObjList = [];
			var len:int = actData.cardList ? actData.cardList.length : 0;
			for (var i:int = 0; i < len; ++i)
			{
				var cardData:CardData = actData.cardList[i] as CardData;
				var cardObj:BaseCardObj = new BaseCardObj(cardData, this);
				cardObjList.push(cardObj);
			}
			
			resetCombatData();
		}
		
		/**
		 * 重置战斗数据 
		 * 
		 */		
		public function resetCombatData():void
		{
			if (!combatData)
				combatData = new CombatData(this);
			combatData.reset(cardObjList);
			
			var len:int = cardObjList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var obj:BaseCardObj = cardObjList[i] as BaseCardObj;
				if (obj)
					obj.resetCombatData();
			}
			
			hp = actData.maxHP;
		}
		
		/**
		 * 增加角色Hp 
		 * @param num
		 * @return 
		 * 
		 */		
		public function addHp(num:int):int
		{
			var temp:int = hp;
			hp = hp + num;
			if (hp > actData.maxHP) hp = actData.maxHP;
			temp = hp - temp;
			
			return temp;
		}
		
		/**
		 * 减少角色Hp 
		 * @param num
		 * @return 
		 * 
		 */		
		public function deductHp(num:int, pushAction:Boolean = true):int
		{
			var temp:int = hp;
			hp = hp - num;
			if (hp < 0) hp = 0;
			temp = temp - hp;
			if (pushAction)
				CombatLogic.combatList.push(DamageNotifyAction.getAction(temp, this.objID));
			
			trace(objID + "当前生命值为:" + hp);
			return temp;
		}
		
		
		/**
		 * 判定是否胜利 
		 * @return 
		 * 
		 */		
		public function checkIsWin():Boolean
		{
			// 参数标记赢，直接判定赢
			if (isWin)
				return true;
			
			if (!enemyActObj)
				return true;
			
			// 目标生命为0，或者战斗区内没有卡牌，则判定自身赢
			if (enemyActObj.hp <= 0)
			{
				trace("对手Hp为0," + objID + "战斗胜利");
				isWin = true;
				return true;
			}
			
			var targetCtData:CombatData = enemyActObj.combatData;
			if (targetCtData.selfCombatArea.length == 0 && targetCtData.selfCardArea.length == 0 && targetCtData.selfWaitArea.length == 0)
			{
				trace("对手卡牌全灭," + objID + "战斗胜利");
				isWin = true;
				return true;
			}
			
			return false;
		}
		
		
		/**
		 *   阶段前的全局技能
		 */ 
		public function preSkill():void
		{	

		}
		
		/**
		 *   卡牌移动到墓地区
		 */ 
		public function cardToCemeteryArea(cardObj:BaseCardObj):void
		{
			if (!cardObj)
				return;
			
			var combatData:CombatData = combatData;
			// 从战斗区,等待区或卡堆中移除
			var idx:int = combatData.selfCombatArea.indexOf(cardObj);
			if (idx > -1)
				combatData.selfCombatArea[idx] = null;	// 位置不变，回合结束后梳理
			else if ((idx = combatData.selfCardArea.indexOf(cardObj)) > -1)
				combatData.selfCardArea.splice(idx, 1);
			else if ((idx = combatData.selfWaitArea.indexOf(cardObj)) > -1)
				combatData.selfWaitArea.splice(idx, 1);
			
			// 添加到墓地区
			if (combatData.selfCemeteryArea.indexOf(cardObj) == -1)
				combatData.selfCemeteryArea.push(cardObj);
			
			// 添加相应操作数据
			CombatLogic.combatList.push(SelectCardToCemeteryArea.getAction(objID, cardObj.objID));
		}
		
		/**
		 * 卡牌复活处理 
		 * @param cardObj
		 * 
		 */		
		public function cardRevive(cardObj:BaseCardObj):void
		{
			if (cardObj == null || combatData.selfCemeteryArea.indexOf(cardObj) == -1)
				return;
			
			// 从墓地中移除
			var idx:int = combatData.selfCemeteryArea.indexOf(cardObj);
			if (idx > -1)
				combatData.selfCemeteryArea.splice(idx, 1);
			
			if (combatData.selfWaitArea.length < MAX_WAIT_NUM)
			{
				// 等待区不满,进入等待区
				if (combatData.selfWaitArea.indexOf(cardObj) == -1)
					combatData.selfWaitArea.push(cardObj);
				
				// 添加相应操作
				cardObj.resetCombatData();
				CombatLogic.combatList.push(SelectCardToWaitAreaAction.getAction(this.objID, cardObj.objID));
			}
			else
			{
				// 等待区已满,进入卡堆
				if (combatData.selfCardArea.indexOf(cardObj) == -1)
					combatData.selfCardArea.push(cardObj);
				
				// 添加相应操作
				CombatLogic.combatList.push(SelectCardToCardAreaAction.getAction(this.objID, cardObj.objID));
			}
		}
		
		/**
		 *  从卡堆随机一张到等待区域
		 */ 
		public function selectCardToWaitArea():void
		{
			// 随机从卡堆挑选一个进入等待区域
			var len:int = combatData.selfCardArea.length;
			if (len <= 0 || combatData.selfWaitArea.length >= MAX_WAIT_NUM)
				return;
			
			var ranIdx:int = len * Math.random();
			var cardObj:BaseCardObj = combatData.selfCardArea[ranIdx];
			combatData.selfCardArea.splice(ranIdx, 1);
			combatData.selfWaitArea.push(cardObj);
			// combatData.selfWaitArea.sortOn("waitRound", Array.NUMERIC);
			
			// 添加相应操作
			cardObj.resetCombatData();
			CombatLogic.combatList.push(SelectCardToWaitAreaAction.getAction(this.objID, cardObj.objID));
		}
		
		/**
		 *  从等待区选择无需等待卡到战斗区域
		 */ 
		public function selectCardToCombatArea():void
		{
			var len:int = combatData.selfWaitArea.length;
			var cardList:Array = [];
			var cardObj:BaseCardObj;
			for (var i:int = 0; i < len; i++)
			{
				cardObj = combatData.selfWaitArea[i];
				if (cardObj.waitRound > 0)
					continue;
				
				// 找到所有进入战斗区的卡牌
				cardList.push(cardObj);
			}
			
			len = cardList.length; 
			for (var j:int = 0; j < len; j++)
			{
				cardObj = cardList[j];
				
				var index:int = combatData.selfWaitArea.indexOf(cardObj);
				combatData.selfWaitArea.splice(index, 1);
				
				combatData.selfCombatArea.push(cardObj);
				
				// 添加相应操作
				CombatLogic.combatList.push(SelectCardToCombatAreaAction.getAction(this.objID, cardObj.objID));
				
				// 处理卡牌降临时
				cardObj.onPresent();
			}
		}
		
		/**
		 *   整个回合结束阶段的处理
		 */ 
		public function roundEndCallback():void
		{
			// 等待区等待回合-1
			var len:int = combatData.selfWaitArea.length;
			for (var i:int = 0; i < len; ++i)
			{
				var cardObj:BaseCardObj = combatData.selfWaitArea[i];
				cardObj.waitRound--;
				if (cardObj.waitRound < 0)
					cardObj.waitRound = 0;
			}
			
			// 自身战斗区卡牌的顺序更新
			len = combatData.selfCombatArea.length;
			for (i = len - 1; i >= 0; --i)
			{
				if (!combatData.selfCombatArea[i])
					combatData.selfCombatArea.splice(i, 1);
			}
		}
		
		/**
		 * 依次计算战斗区中的卡牌 
		 * @return 
		 * 
		 */		
		public function doCombat():Boolean
		{	
			var cardList:Array = combatData.selfCombatArea;
			var len:int = cardList.length;
			for (var i:int = 0; i < len; ++i)
			{
				var cardObj:BaseCardObj = combatData.selfCombatArea[i];
				if (!cardObj)
					continue;
				
				if (cardObj.isDead)
					continue;
				
				if (cardObj.onRoundStart())
					continue;
				
				if (cardObj.onSkill())
					continue;
				
				if (cardObj.onAttack())
					continue;
				
				cardObj.onRoundEnd();
				
				// 检测下对方英雄血条，因为普通攻击涉及到血条变更
				if (checkIsWin() && enemyActObj.hp <= 0)
					return true;
			}
			
			return false;
		}
	}
}