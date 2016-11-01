package chipura.gamecontent 
{
	import chipura.assets.AssetsConst;
	import chipura.managers.LevelManager;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	/**
	 * Абстрактный класс игровых объектов, которые можно размещать на игровом поле
	 * @author Наталья Чипура NatalyChipua@gmail.com
	 */
	public class AContent extends Sprite 
	{
		/**
		 * Формат текста
		 */
		public static const TEXT_FORMAT:TextFormat = new TextFormat("Shadow", 20, 0xFFFFFF, Align.CENTER, Align.BOTTOM);
		// ключ для определения вида по умолчанию
		private const KEY_DEFAULT:String = "Default";
		// контейнер для вида 
		private var viewContainer:Sprite;
		// текущий вид контента (Image или MovieClip)
		protected var view:DisplayObject;
		// набор видов для разной анимации
		protected var _views:Object = new Object();
		
		/**
		 *  ячейка, в которой размещается контент
		 */
		protected var _cell:Point;
		/**
		 * позиция в координатах, в которой находиться контент
		 */
		protected var _position:Point;
		/**
		 * Номер на карте
		 */
		protected var _numMap:uint;
		/**
		 * Контейнер для размещения других экземпляров контента
		 */
		protected var _container:AContent;
		
		/**
		 * Конструктор класса контента 
		 * @param	config конфигурационная XML с данными о текстурах
		 */
		public function AContent(config:XMLList) 
		{
			super();
			
			_cell = new Point();
			_position = new Point();
			
			initViews(config);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
		}
	
		/**
		 * Инициализируем виды
		 * @param	config конфигурационная XML с данными о текстурах
		 */
		private function initViews(config:XMLList):void 
		{
			_views = new Object();
			viewContainer = new Sprite();
			addChild(viewContainer);
			
			_numMap = config.@numMap;
			
			var act:String;
			var cntFrame:uint;
			var loop:Boolean;
			
			// создаем виды в соответствии с полученными данными и текстурами
			for each(var texture:XML in config.children()) {
				act = (texture.hasOwnProperty("@act"))?texture.@act:"";
				cntFrame = (texture.hasOwnProperty("@cntFrame"))?uint(texture.@cntFrame):0;
				loop = (texture.hasOwnProperty("@loop"))?((texture.@loop=="true" || texture.@loop=="1")?true:false):false;
				
				addView(texture.@name, cntFrame, loop, act);
			}
			
			// добавляем вид по умолчанию
			addView(texture.@name, cntFrame, loop, KEY_DEFAULT);
			
		}
		
		/**
		 * Устанавливаем вид
		 * @param	key значение-ключ определяющее вид
		 * @param	isDefault установить вид по умолчанию
		 * @param	isPlay проигрывать анимацию (false для зацикленных анимаций)
		 */
		public function setView(key:String = KEY_DEFAULT,isDefault:Boolean = false,isPlay:Boolean=true):void {
			if (!(key in views)) {
				// если такого вида нет, то выдаем ошибку и отображаем вид по умолчанию
				throw new IllegalOperationError(getQualifiedClassName(this) + ". View '"+key+"' does not exist. Be sure to add it by using the function addView()");	
				key = KEY_DEFAULT;
			}	

			// удаляем предыдущий вид
			if (view && view.hasEventListener(Event.COMPLETE)) {
				view.removeEventListener(Event.COMPLETE, onAnimComplete);	
			}
			viewContainer.removeChild(view);
			
			// устанавливаем новый вид
			view = views[key];
			
			if (isDefault) {
				views[KEY_DEFAULT] = view;
			}
			
			view.alignPivot();
			viewContainer.addChild(view);
			view.name = key;
			
			if (isPlay) gotoAndPlay(0);
			
		}

		/**
		 * Добавить новый вид
		 * @param	nameTexture Название текстуры
		 * @param	cntAnim Количество спрайтов для анимации
		 * @param	loop Зацикленная анимация
		 * @param	nameView ключ-название вида для получения его в дальнейшем
		 */
		public function addView(nameTexture:String, cntAnim:uint = 0, loop:Boolean = true, nameView:String=""):void {
			var obj:DisplayObject;
			
			if (cntAnim > 0) {
				obj = new MovieClip(AssetsConst.atlas.getTextures(nameTexture), cntAnim);
				(obj as MovieClip).loop = loop;
				if (!loop) {
					(obj as MovieClip).play();
				}
				Starling.juggler.add(obj as MovieClip);	
				
			} else {
				obj = new Image(AssetsConst.atlas.getTexture(nameTexture));
			}
	
			_views[nameView] = obj;
			if(nameView == KEY_DEFAULT) setView(KEY_DEFAULT);
			
		}
		
		/**
		 * Поместить контент в ячейку
		 * @param	cell ячейка для размещения
		 */
		public function putTo(cell:Point):void 
		{
			this.cell = cell.clone();
			
			if(view){
				addChild(viewContainer);
			} else {
				throw new IllegalOperationError(getQualifiedClassName(this) + "!!! Need override initView(). Attribute View is DisplayObject: Image or MovieClip, etc.");	
			}
		}
		
		/**
		 * Отобразить зеркально по оси X
		 * @param	direct - направление отражения
		 */
		public function mirrorX(direct:Number):void {
			viewContainer.scaleX = (direct != 0?-direct:viewContainer.scaleX);
		}
		
		/**
		 * Переход по кадрам анимации с остановкой
		 * @param	num Номер кадра
		 */
		protected function gotoAndStop(num:uint = 0):void{
			if(view is MovieClip){
				var movie:MovieClip = (view as MovieClip);
				movie.currentFrame = num;
				movie.pause();
			}
		}
		
		/**
		 * Переход по кадрам анимации с проигрыванием
		 * @param	num Номер кадра
		 */
		protected function gotoAndPlay(num:uint = 0):void{
			if(view is MovieClip){
				var movie:MovieClip = (view as MovieClip);
				movie.currentFrame = num;
				movie.addEventListener(Event.COMPLETE, onAnimComplete);
				movie.play();
			}
		}
		
		/**
		 * Событие завершения анимации
		 * @param	e
		 */		
		private function onAnimComplete(e:Event):void 
		{
			(e.target as MovieClip).removeEventListener(Event.COMPLETE, onAnimComplete);
			setView(KEY_DEFAULT, true, false);
			dispatchEvent(new Event(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE));
			
		}
		
		/**
		 * Удаление контента
		 */
		public function remove():void {
			var content:AContent = this;
			
			// плавное исчезновение
			var tweenFade:Tween = new Tween(content, 2);
			tweenFade.fadeTo(0);
			Starling.juggler.add(tweenFade);
			
			tweenFade.onComplete = function():void {
				Starling.juggler.remove(tweenFade);
				content.removeFromParent(true);
			}	
		}
		
		/**
		 * Событие уничтожения
		 * @param	e
		 */	
		private function onDestroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			for each(var obj:DisplayObject in views) {
				obj.dispose();
				obj.removeEventListeners();
				obj = null;
			}
			_views = null;
			container = null;
			dispose();
		}
		///////////////////////// GETTERs && SETTERs /////////////////////////////////////////////

		public function get cell():Point 
		{
			return _cell;
		}
		
		public function set cell(value:Point):void 
		{
			_cell.setTo(value.x,value.y);
			var pos:Point = LevelManager.convertCellToPos(value);
			_position.setTo(pos.x, pos.y);
			x = _position.x;
			y = _position.y;
		}
		
		public function get position():Point 
		{
			return _position;
		}
		
		public function set position(value:Point):void 
		{
			_position.setTo(value.x,value.y);
			var cell:Point = LevelManager.convertPosToCell(value);
			_cell.setTo(cell.x, cell.y);
			x = _position.x;
			y = _position.y;
		}
		
		public function get views():Object 
		{
			return _views;
		}
		
		public function get numMap():uint 
		{
			return _numMap;
		}
		
		public function get container():AContent 
		{
			return _container;
		}
		
		public function set container(value:AContent):void 
		{
			_container = value;
		}
		
	}

}