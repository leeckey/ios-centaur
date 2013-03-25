package centaur.movies
{
	import centaur.interfaces.IMovieClip;
	import centaur.movies.FanmMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 *   Fanm动画工厂，专门负责生成和回收动画对象，只有这样在大量使用动画时更加高效重利用
	 *   @author wangq 2012.06.27
	 */
	public final class MovieClipFactory
	{
		public static const FAM_MOVIE_TYPE:int = 0;			// Fanm动画类型
		public static const SWF_MOVIE_TYPE:int = 1;			// movieClip动画
		
		/** 动画对象池 */
		private static var _moviePool:Dictionary = new Dictionary();
		
		/** 以名称当为动画登记的关键字  */
		private static var _movieNameDic:Dictionary = new Dictionary();
		
		public static function getPathType(path:String):int
		{
			return (path.indexOf(".swf") != -1) ? SWF_MOVIE_TYPE : FAM_MOVIE_TYPE;
		}
		
		/**
		 *   获取可用的动画对象
		 */ 
		public static function getAvailableMovie(type:int = 0):IMovieClip
		{
			var arrList:Array = _moviePool[type];
			var popObj:IMovieClip = arrList ? arrList.pop() as IMovieClip : null;
			if (popObj)
			{
				delete _movieNameDic[popObj.name];
				return popObj;
			}
			else
			{
				switch (type)
				{
					case FAM_MOVIE_TYPE:
					{
						return new FanmMovieClip(null, -1, false);
					};
//					case SWF_MOVIE_TYPE:
//					{
//						return new FlashMovieClip(null);
//					};
				}
			}
			return null;
		}
		
		/**
		 *   回收动画对象
		 */
		public static function recycleMovie(movie:IMovieClip):void
		{
			if (!movie)
				return;
			
			var movieObj:DisplayObject = movie as DisplayObject;
			movie.clear();
			var parent:DisplayObjectContainer = movie.parent;
			if (parent)
				parent.removeChild(movie as DisplayObject);
			movie.x = 0;
			movie.y = 0;
			movie.rotation = 0;
			movie.scaleX = 1;
			movie.scaleY = 1;
			
			var name:String = movie.name;
			if (!_movieNameDic[name])
			{
				_movieNameDic[name] = movie;
				var movieType:int = movie.type;
				var arrList:Array = _moviePool[movieType];
				if (!arrList)
					_moviePool[movieType] = [movie];
				else
					arrList.push(movie);
			}
		}
	}
}