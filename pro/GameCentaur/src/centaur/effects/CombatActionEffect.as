package centaur.effects
{
	import centaur.interfaces.IMovieClip;
	import centaur.movies.MovieClipFactory;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 *   处于战斗回合时，卡牌的触动效果
	 *   @author wangq 2013.04.26
	 */ 
	public final class CombatActionEffect
	{
		private static var _effectDic:Dictionary = new Dictionary();
		
		private var _target:DisplayObject;			// 显示目标
		private var _offsetY:Number = 0.0;			// 触动时的位置量
		private var _movieClip:IMovieClip;			// 触动时播放的效果
		
		public function CombatActionEffect(target:DisplayObject)
		{
			_target = target;
		}
		
		public static function addActionEffect(target:DisplayObject, offsetY:Number = 0.0):void
		{
			if (!target)
				return;
			
			var actionEffect:CombatActionEffect = _effectDic[target];
			if (!actionEffect)
			{
				actionEffect = _effectDic[target] = new CombatActionEffect(target);
				actionEffect.startEffect(offsetY);
			}
		}
		
		public static function removeActionEffect(target:DisplayObject):void
		{
			if (!target)
				return;
			
			var actionEffect:CombatActionEffect = _effectDic[target];
			if (actionEffect)
			{
				actionEffect.stopEffect();
				delete _effectDic[target];
			}
		}
		
		public function startEffect(offsetY:Number = 0.0):void
		{
			_offsetY = offsetY;
			_target.y += _offsetY;
			
			_movieClip = MovieClipFactory.getAvailableMovie();
			_movieClip.setPath("");
			_movieClip.setLoop(-1);
			_movieClip.play();
			if (_target is DisplayObjectContainer)
				(_target as DisplayObjectContainer).addChild(_movieClip as DisplayObject);
		}
		
		public function stopEffect():void
		{
			MovieClipFactory.recycleMovie(_movieClip);
			if (_target)
			{
				_target.y -= _offsetY;
				_target = null;
			}
		}
	}
}