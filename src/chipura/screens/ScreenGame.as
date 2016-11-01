package chipura.screens 
{
	import chipura.assets.AssetsConst;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * Класс экрана Игры
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	internal class ScreenGame extends AScreen 
	{
		public function ScreenGame() 
		{
			super();
		}
		
		override protected function init():void 
		{
			view = new Sprite();
			
			var fonImg:Image = new Image(AssetsConst.embeds.getTexture("ScreenGameFloor"));
			view.addChild(fonImg);

			_container = new Sprite();
			view.addChild(_container);
			
			fonImg = new Image(AssetsConst.embeds.getTexture("ScreenGameEffect"));
			fonImg.touchable = false;
			view.addChild(fonImg);
		}
		
	}

}