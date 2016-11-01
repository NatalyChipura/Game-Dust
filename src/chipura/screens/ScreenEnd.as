package chipura.screens 
{
	import chipura.assets.AssetsConst;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * Класс эрана окончания игры
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	internal class ScreenEnd extends AScreen 
	{
		
		public function ScreenEnd() 
		{
			super(SCREEN_SHOW_FOREVER, 0.8);
		}
		
		override protected function init():void 
		{
			var fonImg:Image = new Image(Texture.fromEmbeddedAsset(AssetsConst.TextureFonScreen));
			addChild(fonImg);

			fonImg = new Image(Texture.fromEmbeddedAsset(AssetsConst.TextureTitleFailLevel));
			fonImg.alignPivot();
			fonImg.x = stage.stageWidth / 2;
			fonImg.y = stage.stageHeight / 2 -50;
			addChild(fonImg);
			
			addEventListener(TouchEvent.TOUCH, onClick);
		}
		
		/**
		 * Событие клика, по которому экран закрывается
		 * @param	e
		 */
		private function onClick(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if(touch)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					dispatchEvent(new Event(AssetsConst.EVENT_SCREEN_HIDE));
				}
 
			}

		}
		
	}

}