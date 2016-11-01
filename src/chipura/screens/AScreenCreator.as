package chipura.screens 
{
	import chipura.assets.AssetsConst;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * Абстрактный класс Фабрики экранов
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	internal class AScreenCreator extends Sprite
	{
		/**
		 * Контейнер, куда размещать экран
		 */
		private var target:DisplayObjectContainer;
		/**
		 * Экземпляр экрана
		 */
		private var screen:AScreen;
		
		public function AScreenCreator() {	}
		
		/**
		 * Задать экран
		 * @param	type тип экрана
		 * @param	target контейнер для размещения экрана.
		 */
		public function setScreen(type:String,target:DisplayObjectContainer=null):void {
			// создаем экран
			screen = createScreen(type);	
			// размещаем экран 
			this.target = (target==null?this:target);
			this.target.addChild(screen);
			screen.name = type;
			screen.addEventListener(AssetsConst.EVENT_SCREEN_HIDE, onHideScreen);
			// показываем
			screen.show();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
		}
		
		/**
		 * Событие уничтожения
		 * @param	e
		 */
		private function onDestroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			dispose();
		}
		
		/**
		 * Разместить контент в контейнере экрана
		 * @param	child объект размещения
		 * @param	pos позиция, куда помещать
		 */
		public function putContainer(child:DisplayObject, pos:Point):void {
			
			screen.container.addChild(child);
			child.x = pos.x;
			child.y = pos.y;
		}
		
		/**
		 * Событие сокрытия экрана
		 * @param	e
		 */
		private function onHideScreen(e:Event):void 
		{
			screen.removeEventListener(AssetsConst.EVENT_SCREEN_HIDE, onHideScreen);
			screen.removeFromParent(true);
			dispatchEvent(new Event(AssetsConst.EVENT_SCREEN_HIDE));
		}
		
		// Абстрактный метод (должен быть замещен в подклассе)
		protected function createScreen(type:String):AScreen
		{
			throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
			return null;
		}
	}

}