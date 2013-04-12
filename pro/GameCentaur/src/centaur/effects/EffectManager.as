package centaur.effects
{
	import centaur.data.effects.EffectData;
	
	import flash.display.Sprite;

	public final class EffectManager
	{
		public function EffectManager()
		{
		}
		
		public function renderEffect(data:EffectData):RenderEffectBase
		{
			var effect:RenderEffectBase = getAvailableEffect(data);
			effect.startEffect();
			return effect;
		}
		
		private function getAvailableEffect(data:EffectData):RenderEffectBase
		{
			return new RenderEffectBase(data);	
		}
		
		public function renderEffectByPath(path:String, parentObj:Sprite, loop:int = 1):RenderEffectBase
		{
			if (!path)
				return null;
			
			var data:EffectData = new EffectData();
			data.effectPath = path;
			data.loop = loop;
			data.parentObj = parentObj;
			
			return renderEffect(data);
		}
	}
}