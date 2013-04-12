package centaur.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import mcyy.ui.common.*;
	
	public class NumberCache
	{
		//红色
		private static var _redNumberSource:Array = [];
		//绿色
		private static var _greenNumberSource:Array = [];
		//黄色
		private static var _yellowNumberSource:Array = [];
		//紫色
		private static var _purpleNumberSource:Array = [];
		//白色
		private static var _whiteNumberSource:Array = [];
		//暴击
		private static var _criticalHitNumberSource:Array = [];
		//经验(蓝色)
		private static var _expNumberSource:Array = [];
		// 战斗力(金)
		private static var _glodNumberSource:Array = [];
		// 绿(战斗力)
		private static var _f_greenNumberSource:Array = [];
		// 红(战斗力)
		private static var _f_redNumberSource:Array = [];
		// 黑
		private static var _blackNumberSource:Array = [
			new BlackNumber0Asset(),
			new BlackNumber1Asset(),
			new BlackNumber2Asset(),
			new BlackNumber3Asset(),
			new BlackNumber4Asset(),
			new BlackNumber5Asset(),
			new BlackNumber6Asset(),
			new BlackNumber7Asset(),
			new BlackNumber8Asset(),
			new BlackNumber9Asset()
		];
		
		public static var _fightPowerWordAsset:BitmapData = null;		// 战斗力		
		private static var _whiteCriticalHitAsset:BitmapData = null;	//白色暴击字
		private static var _orangeCriticalHitAsset:BitmapData = null;	//橙色暴击字
		private static var _whiteBlockAsset:BitmapData = null;		//白色格挡
		private static var _yellowBlockAsset:BitmapData = null;		//黄色格挡
		private static var _blueExpAsset:BitmapData = null;			//蓝色经验
		public static var _personChopAsset:BitmapData = null;				//人斩
		public static var _bloodGgAsset:BitmapData = null;
		private static var _resist:BitmapData = null;		// 抵抗
		private static var _selfResist:BitmapData = null;	// 自身抵抗
		
		/**作为getNumber取的对象池子 2012-11-1*/
		private static var _poolBitmap:Array = [];
		private static var _poolSprite:Array = [];
		
		private static function getBitmap(bd:BitmapData):Bitmap
		{
			if(!bd)
				return null;			// 如果db为空的时候
			var bmp:Bitmap;
			if(_poolBitmap.length)
			{
				bmp = _poolBitmap.shift();
			}
			else
			{
				bmp = new Bitmap;
			}
			bmp.bitmapData = bd;
			bmp.width = bd.width;
			bmp.height = bd.height;
			
			return bmp;
		}
		
		public static const delaySprite:Sprite = new Sprite;			// 用做延迟的对象
		
		private static function getSprite():Sprite
		{
			if(_poolSprite.length)
				return _poolSprite.shift();
			return new Sprite;
		}
		/**回收对象*/
		public static function recycle(o:Sprite):void
		{
			var bmp:Bitmap;
			while(o.numChildren)
			{
				bmp = o.removeChildAt(0) as Bitmap;
				bmp.bitmapData = null;
				bmp.width = bmp.height = 0;
				_poolBitmap.push(bmp);
			}
			//o.width = o.height = 0;
			_poolSprite.push(o);
		}
		
		public static function clearPool():void
		{
			_poolSprite.length = 0;
			_poolBitmap.length = 0;
		}
		/*******************************/
		public static function getNumber(value:int,type:int,color:String = ""):Sprite
		{
			var t:String = value.toString();
			if(type != NumberType.FIGHT_CHANGE_CUR && type != NumberType.PERSONCHOP)			// 战斗力不加		人斩也不加
			{
				if(value > 0)t = "+" + t;
				else if(value == 0)
				{
					if(type == NumberType.FIGHT_CHAGNE_MINUS || type == NumberType.FIGHT_CHANGE_PLUS)
						t = "0";
					else
						t = "";
				}
			}
			// 这边做下延迟处理
			var bDelay:Boolean = false;
			
			var sp:Sprite = getSprite();
			var bmp:Bitmap;
			
			if(type == NumberType.CRITICAL_SKILL || type == NumberType.CRITICAL_SKILL_ME)	// 橙色暴击
			{
				bmp = getBitmap(_orangeCriticalHitAsset);
			}
			else if(type == NumberType.CRITICAL_PHY)	// 白色暴击
			{
				bmp = getBitmap(_whiteCriticalHitAsset);
			}
			else if(type == NumberType.BLOCK_SKILL || type == NumberType.BLOCK_SKILL_ME)	// 黄色格挡
			{
				bmp = getBitmap(_yellowBlockAsset);
			}
			else if(type == NumberType.BLOCK)		// 白色格挡
			{
				bmp = getBitmap(_whiteBlockAsset);
			}
			else if(type == NumberType.EXP)		// 经验蓝色
			{
				bmp = getBitmap(_blueExpAsset);
			}
			else if (type == NumberType.SELF_RESIST)	// 自身抵抗
			{
				bmp = getBitmap(_selfResist);
			}
			else if (type == NumberType.OTHER_RESIST)	// 其他人抵抗
			{
				bmp = getBitmap(_resist);
			}
			else if(t == "")
			{
				recycle(sp);
				return null;
			}
			
			if(bmp)
			{
				bmp.x = sp.width;
				sp.addChild(bmp);
			}
			else		// 没有资源
			{
				if(getBD(type))
					bDelay = true;
			}
			
			var list:Array = getList(type,color);			// 取字体
			var tLen:int = t.length;
			for(var i:int = 0; i < tLen; i++)
			{
				var tmpIdx:int = getIndex(t.charAt(i));
				if(tmpIdx < list.length)
					bmp = getBitmap(list[tmpIdx]);
				else
					bmp = null;
				
				if(bmp)
				{
					bmp.x = sp.width;
					sp.addChild(bmp);
				}
				else			// 没有数字资源
				{
					if(getBD(type , t.charAt(i)))
						bDelay = true;
				}
			}
			
			if(bDelay)				// 需要延迟处理
			{
				recycle(sp);
				return delaySprite;
			}
			
			return sp;
		}
		/**获取bitmapData数据*/
		private static function getBD(type:int , num:String = "" , color:String = ""):Boolean
		{
			var path:String = "assets/img/num/";
			if(num != "")			// 有数字的
			{
				switch(type)
				{
					case NumberType.NORMAL_PHY_ME:
					case NumberType.NORMAL_SKILL_ME:
						path += "red/";
						break;
					case NumberType.ADDBLOOD:
					case NumberType.CHOP:
						path += "green/";
						break;
					case NumberType.BLOCK_SKILL:
					case NumberType.BLOCK_SKILL_ME:
					case NumberType.NORMAL_SKILL:
						path += "yellow/";
						break;
					case NumberType.BUFF_DAMAGE:
						path += "purple/"
						break;
					case NumberType.CRITICAL_PHY:
					case NumberType.BLOCK:
					case NumberType.NORMAL_PHY:
						path += "white/";
						break;
					case NumberType.CRITICAL_SKILL:
					case NumberType.CRITICAL_SKILL_ME:
						path += "critical/";
						break;
					case NumberType.EXP:
						path += "exp/";
						break;
					case NumberType.FIGHT_CHANGE_CUR:
						path += "glod/";
						break;
					case NumberType.FIGHT_CHANGE_PLUS:
						path += "fgreen/";
						break;
					case NumberType.FIGHT_CHAGNE_MINUS:
						path += "fred/";
						break;
					case NumberType.PERSONCHOP:
						path += "black/";
						return false;
						break;
					case NumberType.HIT:
						if(color == "yellow")
							path += "yellow/";
						else
							path += "red/";
						break;
					default:
						return false;
				}
				path += num + ".png";
			}
			else
			{
				switch(type)
				{
					case NumberType.CRITICAL_SKILL:
					case NumberType.CRITICAL_SKILL_ME:
						path += "orange_ctri";
						break;
					case NumberType.CRITICAL_PHY:
						path += "white_ctri";
						break;
					case NumberType.BLOCK_SKILL:
					case NumberType.BLOCK_SKILL_ME:	
						path += "yellow_block";
						break;
					case NumberType.BLOCK:
						path += "white_block"
						break;
					case NumberType.EXP:
						path += "self_resist";		// 代替经验先
						break;
					case NumberType.SELF_RESIST:
						path += "self_resist";
						break;
					case NumberType.OTHER_RESIST:
						path += "resist";
						break;
					default:
						return false;
				}
				path += ".png";
			}
			// 加载图片
//			GlobalAPI.loaderAPI.getPicFile(GlobalAPI.pathManager.site + path , loadComplete , SourceClearType.NEVER , int.MAX_VALUE , LoaderTeamType.FRONT);
			return true;
		}
//		/**图片加载完成*/
//		private static function loadComplete(bd:BitmapData , loader:ILoader):void
//		{
//			var path:String = loader.path;
//			var type:int = -1;
//			if(path.indexOf("/green/") != -1)		// 绿
//			{
//				type = NumberType.ADDBLOOD;
//			}
//			else if(path.indexOf("/exp/") != -1)			// 蓝
//			{
//				type = NumberType.EXP;
//			}
//			else if(path.indexOf("/critical/") != -1)		// 暴击
//			{
//				type = NumberType.CRITICAL_SKILL;
//			}
//			else if(path.indexOf("/fgreen/") != -1)			// 战斗力
//			{
//				type = NumberType.FIGHT_CHANGE_PLUS;
//			}
//			else if(path.indexOf("/glod/") != -1)
//			{
//				type = NumberType.FIGHT_CHANGE_CUR;
//			}
//			else if(path.indexOf("/fred/") != -1)
//			{
//				type = NumberType.FIGHT_CHAGNE_MINUS;
//			}
//			else if(path.indexOf("/red/") != -1)
//			{
//				type = NumberType.NORMAL_PHY_ME;
//			}
//			else if(path.indexOf("/white/") != -1)
//			{
//				type = NumberType.NORMAL_PHY;
//			}
//			else if(path.indexOf("/yellow/") != -1)
//			{
//				type = NumberType.NORMAL_SKILL;
//			}
//			else if(path.indexOf("/purple/") != -1)
//			{
//				type = NumberType.BUFF_DAMAGE;
//			}
//			else if(path.indexOf("/black/") != -1)
//			{
//				type = NumberType.CHOP;
//			}
//			else if(path.indexOf("orange_ctri") != -1)
//			{
//				_orangeCriticalHitAsset = bd;
//			}
//			else if(path.indexOf("white_ctri") != -1)
//			{
//				_whiteCriticalHitAsset = bd;
//			}
//			else if(path.indexOf("yellow_block") != -1)
//			{
//				_yellowBlockAsset = bd;
//			}
//			else if(path.indexOf("white_block") != -1)
//			{
//				_whiteBlockAsset = bd;
//			}
//			else if(path.indexOf("self_resist") != -1)
//			{
//				_selfResist = bd;
//			}
//			else if(path.indexOf("resist") != -1)
//			{
//				_resist = bd;
//			}
//			// 数字
//			if(type != -1)
//			{
//				var list:Array = getList(type , "");
//				var len:int = path.length;
//				var num:String = path.substring(len-5 , len-4);
//				list[getIndex(num)] = bd;
//			}
//		}
		// 数字索引
		private static function getIndex(str:String):int
		{
			switch(str)
			{
				case "0":return 0;
				case "1":return 1;
				case "2":return 2;
				case "3":return 3;
				case "4":return 4;
				case "5":return 5;
				case "6":return 6;
				case "7":return 7;
				case "8":return 8;
				case "9":return 9;
				case "-":return 10;
				case "+":return 11;
			}
			return 0;
		}
		// 数字源列表
		private static function getList(type:int,color:String):Array
		{
			switch(type)
			{
				case NumberType.HIT:
					if(color == "yellow")return _yellowNumberSource;
					else return _redNumberSource;
				case NumberType.CRITICAL_SKILL:		// 暴击
				case NumberType.CRITICAL_SKILL_ME:	// 我被暴击
					return _criticalHitNumberSource;
				case NumberType.BLOCK_SKILL:		// 格挡
				case NumberType.BLOCK_SKILL_ME:
				case NumberType.NORMAL_SKILL:
					return _yellowNumberSource;
				case NumberType.NORMAL_PHY_ME:
					return _redNumberSource;
				case NumberType.CRITICAL_PHY:	// 普通攻击暴击
				case NumberType.BLOCK:			// 普通攻击格挡
				case NumberType.NORMAL_PHY:		// 普通攻击
					return _whiteNumberSource;
				case NumberType.NORMAL_SKILL_ME:	// 我被攻击
					return _redNumberSource;
				case NumberType.EXP:		// 经验
					return _expNumberSource;
				case NumberType.ADDBLOOD:	// 加血
					return _greenNumberSource;
				case NumberType.CHOP:		// 斩
					return _greenNumberSource;
				case NumberType.PERSONCHOP:	// 人斩
					return _blackNumberSource;
				case NumberType.FIGHT_CHANGE_CUR:			// 金色
					return _glodNumberSource;
				case NumberType.FIGHT_CHANGE_PLUS:			// 绿色
					return _f_greenNumberSource;
				case NumberType.FIGHT_CHAGNE_MINUS:			// 红色
					return _f_redNumberSource;
				case NumberType.BUFF_DAMAGE:			// 紫色
					return _purpleNumberSource;
			}
			return [];
		}
	}
}