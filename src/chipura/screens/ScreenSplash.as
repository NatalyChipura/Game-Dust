package chipura.screens 
{
	import chipura.assets.AssetsConst;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * Класс экрана с Логотипом
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	public class ScreenSplash extends AScreen 
	{
		
		public function ScreenSplash() 
		{
			super(AssetsConst.SCREEN_TIMESHOW+2, SCREEN_APPEAR_INSTANTLY);
		}
		
		override protected function init():void 
		{
			var fonImg:Image = new Image(Texture.fromEmbeddedAsset(AssetsConst.TextureSplashScreen));
			fonImg.alignPivot();
			fonImg.x = stage.stageWidth / 2;
			fonImg.y = stage.stageHeight / 2;
			addChild(fonImg);		
		}
		
	}

}