package chipura.gamecontent.actions.motions 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.landscape.LandFactory;
	import chipura.managers.LevelManager;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	/**
	 * Абстрактный класс Движения
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class AMotion
	{
		// алгоритм движения Кратчайшего пути
		public static const DISTANCE_SHORT:uint = 0;
		// алгоритм движения На наибольшую дистанцию
		public static const DISTANCE_LONG:uint = 1;
		// алгоритм движения Случайный выбор
		public static const DISTANCE_RAND:uint = 2;
		
		
		// параметры линейного движения к заданной точке
		private var content:AContent;
		private var timeMove:Number;
		private var velocity:Point;
		
		public function AMotion() 
		{
			
		}
		
		/**
		 * Выполнить движение
		 * @param	obj контент, который совершает движение
		 * @param	cell ячейка, в которую движется объект
		 * @param	howMove алгоритм движения, задается константами  
		 * @return  целевая ячейка, которую определили для перемещения
		 */
		public function execute(obj:AContent, cell:Point, howMove:uint):Point {
			throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
		}
		
		/**
		 * Масштабировать вектор движения к движению на N ячеек
		 * @param	vectCell Вектор движения в значениях ячеек
		 * @param	howMove Алгоритм движения
		 * @param	cntCell Количество ячеек, на которое перемещаться
		 * @return
		 */
		protected function scaleToNCell(vectCell:Point, howMove:uint =  DISTANCE_LONG, cntCell:Number = 1 ):Point {
			
			var vector:Point = vectCell.clone();
			// номализуем в соответствии с количеством ячеек для перемещения
			vector.normalize(cntCell);
			
			// приводим вектор к целому значению и выбираем направления в зависимости от алгоритма
			if (Math.abs(vector.x) == Math.abs(vector.y)) {
				// если направления равны, предпочтем направление без препятствий
				vector.setTo(signCeil(vector.x), signCeil(vector.y));
			} else {
				switch(howMove) {
					case DISTANCE_LONG: {
						// выбираем направление по наибольшей оси вектора
						if (Math.abs(vector.x) > Math.abs(vector.y)) {
							vector.setTo(signCeil(vector.x), 0);
						} else if (Math.abs(vector.x) < Math.abs(vector.y)) {
							vector.setTo(0, signCeil(vector.y));	
						} 
					}break;
					case DISTANCE_SHORT: {
						// выбираем направление по наименьшей оси вектора
						if (Math.abs(vector.x) >0 && Math.abs(vector.x) < Math.abs(vector.y)) {
							vector.setTo(signCeil(vector.x), 0);
						} else if (Math.abs(vector.y) >0 &&  Math.abs(vector.y) < Math.abs(vector.x)) {
							vector.setTo(0, signCeil(vector.y));	
						} 
					}break;
					case DISTANCE_RAND: {
						// выбираем направление случайно
						if (Math.abs(vector.x) == 0 ) {
							vector.setTo(0, signCeil(vector.y));	
						} else if (Math.abs(vector.y) == 0) {
							vector.setTo(signCeil(vector.x), 0);
						} else {
							switch(Math.ceil(Math.random() * 2)) {
								case 1: vector.setTo(0, signCeil(vector.y)); break;
								case 2: vector.setTo(signCeil(vector.x), 0); break;
							}
						}
					}break;
				}
			}			
			
			return vector;
		}
		
		/**
		 * Приведение числа к наибольшему значению в сторону знака (9.9 = 10 , а -9.9 = -10)
		 * @param	n число
		 * @return  привденное число
		 */
		protected function signCeil(n:Number):Number {
			return (n >= 0)?Math.ceil(n):Math.floor(n);
		}
		
		/**
		 * Плавное движение к ячейке
		 * @param	content контент, который нужно перемещать
		 * @param	cell ячейка, в которую нужно переместить
		 * @param	sec время перемещения
		 */
		protected function tweenToCell(content:AContent, cell:Point, sec:Number):void 
		{
			var pos:Point = LevelManager.convertCellToPos(cell);
			
			var tweenMove:Tween = new Tween(content,sec);
			tweenMove.moveTo(pos.x,pos.y);
			tweenMove.transition = Transitions.EASE_IN;
					  
			Starling.juggler.add(tweenMove);
			tweenMove.onComplete = function():void {
				Starling.juggler.remove(tweenMove);
				content.cell = cell.clone();	
			}
		}
		
		/**
		 * Линейное плавное преемещение
		 * @param	content контент, который нужно перемещать
		 * @param	cell ячейка, в которую нужно переместить
		 * @param	sec время перемещения
		 */
		protected function moveToCell(content:AContent, cell:Point, sec:Number):void 
		{			
			this.content = content;
			
			var distance:Point = this.content.cell.subtract(cell);
			timeMove = Starling.current.nativeStage.frameRate * sec;
			velocity = new Point(distance.x * AssetsConst.MAP_CELL_WIDTH / timeMove, distance.y * AssetsConst.MAP_CELL_HEIGHT / timeMove);
			
			this.content.addEventListener(EnterFrameEvent.ENTER_FRAME, onMove);
		}
		
		private function onMove(e:EnterFrameEvent):void 
		{
			if (timeMove>0) {
				this.content.position = this.content.position.subtract(velocity);
				timeMove--;
			} else {
				this.content.dispatchEvent(new Event(AssetsConst.EVENT_ACT_MOTION_COMPLETE));
				this.content.removeEventListener(EnterFrameEvent.ENTER_FRAME, onMove);
			}
		}
		
		
		
		
		
	}

}