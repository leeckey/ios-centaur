package centaur.scene.view
{
	import com.citrusengine.view.starlingview.StarlingArt;
	import com.citrusengine.view.starlingview.StarlingView;
	
	import starling.display.Sprite;

	/**
	 * 
	 */ 
	public final class GameView extends StarlingView
	{
		protected var _gameSprite:Sprite;
		
		public function GameView(root:Sprite)
		{
			super(root);
			_gameSprite = viewRoot;
		}
		
		override public function update():void
		{//super.update();
			if (cameraTarget)
			{
				var targetX:Number = cameraTarget.x;
				var targetY:Number = cameraTarget.y;
				
				// 水平方向
				if (targetX < 0)
					cameraTarget.x = cameraLensWidth;
				else if (targetX > cameraLensWidth)
					cameraTarget.x = 0;
				
				// 垂直方向
				var topY:Number = (targetY - cameraLensHeight * 0.5);
				if (_gameSprite.y < -topY)
					_gameSprite.y = -topY;
			}
			
			// Update art positions
			for each (var sprite:StarlingArt in _viewObjects) {
				if (sprite.group != sprite.citrusObject.group)
					updateGroupForSprite(sprite);
				
				sprite.update(this);
			}
		}
		
		private function updateGroupForSprite(sprite:StarlingArt):void {
			// Create the container sprite (group) if it has not been created yet.
			var group:int = sprite.group;
			while (group >= _gameSprite.numChildren)
				_gameSprite.addChild(new Sprite());
			
			// Add the sprite to the appropriate group
			Sprite(_gameSprite.getChildAt(group)).addChild(sprite);
		}
	}
}