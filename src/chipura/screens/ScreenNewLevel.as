package chipura.screens 
{
	import chipura.assets.AssetsConst;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * Класс экрана Нового Уровня (переход между уровнями)
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	internal class ScreenNewLevel extends AScreen 
	{
		
		public function ScreenNewLevel() 
		{
			super(AssetsConst.SCREEN_TIMESHOW);
		}
		
		override protected function init():void 
		{
			var fonImg:Image = new Image(Texture.fromEmbeddedAsset(AssetsConst.TextureFonScreen));
			addChild(fonImg);

			fonImg = new Image(Texture.fromEmbeddedAsset(AssetsConst.TextureTitleNewLevel));
			fonImg.alignPivot();
			fonImg.x = stage.stageWidth / 2;
			fonImg.y = stage.stageHeight / 2 -50;
			addChild(fonImg);
		
		}
		
	}

}