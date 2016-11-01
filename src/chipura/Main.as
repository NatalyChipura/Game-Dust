package chipura
{
	import chipura.assets.AssetsConst;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import starling.events.Event;
	
	import starling.utils.AssetManager;
	import starling.core.Starling;
	
	/**
	 * Главный класс игры Dust
	 * @author Наталья Чипура (natalychipura@gmail.com)
	 * 
	 */
	public class Main extends Sprite 
	{
		/**
		 * Менеджер ассетов
		 */
		private var assetsEmbed:AssetManager;
		private var mStarling:Starling;
		
		public function Main() 
		{
			assetsEmbed = new AssetManager();
			assetsEmbed.enqueue(AssetsConst);	
			
			// иницилизация Starling
			initStarling();
		}
		
		private function initStarling():void {
		    var fullscreenArea:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            var viewport:Rectangle = fullscreenArea;
            
            mStarling = new Starling(Preloader, stage, viewport,null,"auto","auto");
        
            // показывать статистику
			mStarling.showStats = true;
           
            mStarling.antiAliasing = 1;
			mStarling.addEventListener(Event.ROOT_CREATED, onRootCreated);
        }
		
		private function onRootCreated(event:Object, app:Preloader):void
		{
			mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			app.load(assetsEmbed);
			mStarling.start();
		}
		
	}
	
}