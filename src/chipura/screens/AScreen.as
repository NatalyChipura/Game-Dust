package chipura.screens 
{
	import chipura.assets.AssetsConst;
	
	import flash.errors.IllegalOperationError;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	
	/**
	 * Абстрактный класс игровго экрана
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	internal class AScreen extends Sprite 
	{
		/**
		 * Показывать экран всегда, пока не закроем принудительно
		 */
		protected const SCREEN_SHOW_FOREVER:Number = 0;
		/**
		 * Мгновенное появление
		 */
		protected const SCREEN_APPEAR_INSTANTLY:Number = 0;
		
		// Вид экрана
		protected var view:Sprite;
		/**
		 * Контейнер для размещения объектов на экране
		 */
		protected var _container:Sprite;
		
		// время показа
		protected var timeShow:uint;
		// время появления
		protected var timeAppear:uint;
		
		/**
		 * Конструктор абстрактного класса экрана
		 * @param	tmShow время показа
		 * @param	tmAppearance время появления
		 */
		public function AScreen(tmShow:Number=SCREEN_SHOW_FOREVER,tmAppearance:Number = SCREEN_APPEAR_INSTANTLY) 
		{
			super();
			
			view = new Sprite();
			
			timeShow = tmShow;
			timeAppear = tmAppearance;
			
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
		}
		
		/**
		 * Состояние уничтожения
		 * @param	e
		 */
		private function onDestroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			dispose();
		}

		/**
		 * Показать экран
		 */
		public function show():void {
			// инициализация вида
			init();
		  
			if(!_container){
				_container = new Sprite();
			} 
			
			addChild(_container);
			
			// появление
			Appearance();			
		}
		
		/**
		 * Исчезновение экрана
		 */ 
		private function Disappearance():void 
		{
			var tweenFade:Tween = new Tween(view, 1.5);
			tweenFade.fadeTo(0);
			tweenFade.transition = Transitions.EASE_IN;
		  
			Starling.juggler.add(tweenFade);
			
			tweenFade.onComplete = function():void {
				Starling.juggler.remove(tweenFade);
				removeChild(view);
				dispatchEvent(new Event(AssetsConst.EVENT_SCREEN_HIDE));
			}
		}
		
		/**
		 * Появление экрана
		 */
		private function Appearance():void 
		{
			super.addChild(view);
			
			if(timeAppear!=SCREEN_APPEAR_INSTANTLY){
				view.alpha = 0;
				var tweenFade:Tween = new Tween(view,timeAppear);
				tweenFade.fadeTo(1);
				tweenFade.transition = Transitions.EASE_IN;
					  
				Starling.juggler.add(tweenFade);
						
				tweenFade.onComplete = function():void {
					Starling.juggler.remove(tweenFade);
				}
			}
			
			if(timeShow!=AssetsConst.SCREEN_SHOW_FOREVER){
				Starling.juggler.delayCall(Disappearance ,timeShow);
			}
		}
		
		/**
		 * Инициализация вида экрана 
		 */
		protected function init():void 
		{
			throw new IllegalOperationError("Need override init(). Fon's Sprite is not init (view or fonTexture). And set TimeShow if need hide screen and  set content sprite if your need.");	
		}
		
		/**
		 * Добавить элемент на экран
		 * @param	child
		 * @return
		 */
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			view.addChild(child);
			return child;
		}
		
		///////////////////////////// GETTERs && SETTERs //////////////////////////////////////////
		public function get container():Sprite 
		{
			return _container;
		}
		
		
	}

}