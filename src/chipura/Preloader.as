package chipura
{
	import chipura.assets.AssetsConst;
	import chipura.screens.ScreenFactory;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFormat;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	import starling.core.Starling;
	
	/**
	 * Класс предзагрузки
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	public class Preloader extends Sprite
	{
		private var assetsEmbed:AssetManager;
		private var panel:ScreenFactory;

		public function Preloader()
		{
		
		}
		
		/**
		 * Загрузка контента
		 * @param	assetsMng - Менеджер контента AssetManager
		 */
		public function load(assetsMng:AssetManager = null):void
		{
			assetsEmbed = AssetsConst.embeds = assetsMng;
			splashScreen();
		}
		
		/**
		 * Процесс загрузки
		 */
		private function loaderScreen():void 
		{
			var txtFormat:TextFormat = new TextFormat("Shadow", 22, 0xFFFFFF);
			var progressText:TextField = new TextField(300, 100, "", txtFormat);
			progressText.alignPivot();
			progressText.x = stage.stageWidth / 2;
			progressText.y = stage.stageHeight / 2;
			addChild(progressText);
			
			assetsEmbed.loadQueue(function onProgress(ratio:Number):void
			{
				
				progressText.text = "Загрузка..." + Math.ceil(ratio * 100).toString() + "%";
				
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						removeChild(progressText);
											
						//Инициализируем Атлас текстур
						var texture:Texture = AssetsConst.embeds.getTexture("atlasGameObjTexture");
						var xml:XML = XML(AssetsConst.embeds.getXml("atlasGameObjXml"));
						AssetsConst.atlas = new TextureAtlas(texture, new XML(xml.TextureAtlas));
						
						// Переходим к игре
						addChild(new GameInterface());
							
					}, 0.5);
			});
			
		}
		
		
		/**
		 * Вызов экрана с логотипом
		 */
		private function splashScreen():void
		{
			stage.color = 0xFFFFFF;
			
			panel = new ScreenFactory();
			addChild(panel);
			panel.setScreen(ScreenFactory.SCREEN_SPLASH);
			panel.addEventListener(AssetsConst.EVENT_SCREEN_HIDE, onSplahHide);
		}
		
		/**
		 * Событие сокрытия экрана с логотипом
		 * @param	e
		 */
		private function onSplahHide(e:Event):void 
		{
			panel.removeEventListener(AssetsConst.EVENT_SCREEN_HIDE, onSplahHide);
			removeChild(panel);
			panel.dispose();
			panel = null;
			
			stage.color = 0x1E0D09;
			
			var fonImg:Image = new Image(Texture.fromEmbeddedAsset(AssetsConst.TextureFonScreen));
			addChild(fonImg);
			
			loaderScreen();
		}
	
	}

}