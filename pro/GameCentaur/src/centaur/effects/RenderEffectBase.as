package centaur.effects
{
	import centaur.data.GlobalAPI;
	import centaur.data.effects.EffectData;
	import centaur.interfaces.IMovieClip;
	import centaur.movies.MovieClipFactory;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 *  效果播放基类
	 */ 
	public class RenderEffectBase
	{
		private var _data:EffectData;
		private var _movieClip:IMovieClip;
		
		public function RenderEffectBase(data:EffectData)
		{
			_data = data;
		}
		
		public function startEffect():void
		{
			if (!_data || !_data.parentObj)
				return;
			
			_movieClip = MovieClipFactory.getAvailableMovie();
			_movieClip.setLoop(_data.loop);
			_movieClip.setPath(_data.effectPath);
			_movieClip.addEventListener(Event.COMPLETE, onMovieComplete);
			_movieClip.play();
			
			// 默认居中显示到目标上
			var gPoint:Point = _data.parentObj.localToGlobal(new Point(_data.parentObj.width * 0.5, _data.parentObj.height * 0.5));
			(_movieClip as DisplayObject).x = gPoint.x;
			(_movieClip as DisplayObject).y = gPoint.y;
			GlobalAPI.layerManager.getTipLayer().addChild(_movieClip as DisplayObject);
		}
		
		private function onMovieComplete(e:Event):void
		{
			//  清理动画事件等，下次可以重利用
			if (_movieClip)
			{
				_movieClip.removeEventListener(Event.COMPLETE, onMovieComplete);
				MovieClipFactory.recycleMovie(_movieClip);
				_movieClip = null;
			}
			_data = null;
		}
	}
}