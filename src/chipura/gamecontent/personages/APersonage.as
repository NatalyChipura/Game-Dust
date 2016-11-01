package chipura.gamecontent.personages
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.actions.attacks.IAttack;
	import chipura.gamecontent.actions.motions.AMotion;
	import chipura.gamecontent.actions.motions.MoveOneCell;
	
	import flash.geom.Point;

	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Align;
	
	/**
	 * Абстрактный класс Персонаж для участников игры (герой и противники)
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class APersonage extends AContent
	{
		// текстовое поле для вывода значения здоровья персонажа
		private var tfHealth:TextField;
		// текстовое поле для вывода значения урона персонажа
		private var tfDamage:TextField;
		
		/**
		 * Здоровье персонажа
		 */
		protected var _health:int;
		/**
		 * Урон персонажа
		 */
		protected var _damage:int;
		
		// текущее движение
		protected var motion:AMotion;
		// текущая атака
		protected var attack:IAttack;
		
		/**
		 * Конструктор класса Персонаж 
		 * @param	config конфигурационная XML с данными о текстурах
		 */
		public function APersonage(config:XMLList)
		{
			super(config);
			
			initTextField();
		}

		/**
		 * Выполнить движение
		 * @param	cell ячейка, в которую направить персонажа
		 * @param	howMove вариант движения
		 * 			Определяется констатнами движения класса AMotion (package chipura.gamecontent.actions.motions): 
		 * 			• DISTANCE_LONG  - длинный путь (вариант быстрого перемещения);
		 * 			• DISTANCE_SHORT - короткий путь (вариант кратчайшего пути);
		 *			• DISTANCE_RAND -  случайный путь ;
		 * @return  целевая ячейка (ячейка приведенная к формату движения)
		 */
		public function doMove(cell:Point, howMove:uint):Point
		{
			return motion.execute(this, cell, howMove);
		}
		
		/**
		 * Выполнить атаку
		 * @param	obj Контент, который атакуем
		 */
		public function doAttack(obj:AContent):void
		{
			attack.execute(this, obj);
		}
		
		/**
		 * Установить новое движение
		 * @param	newMotion экземпляр класс движения
		 */
		public function setMotion(newMotion:AMotion):void
		{
			motion = newMotion;
		}
		
		/**
		 * Установить новую атаку
		 * @param	newAttack экземпляр класс атаки
		 */
		public function setAttack(newAttack:IAttack):void
		{
			attack = newAttack;
		}
		   
		/**
		 * Инициализация текстовых полей
		 */   
		private function initTextField():void 
		{
			tfHealth = new TextField(5, 30, "", TEXT_FORMAT);
			addChild(tfHealth);
			tfHealth.y = -view.height / 2 ;
			tfHealth.format.color = 0xbed668;
				
			tfDamage = new TextField(5, 30, "", TEXT_FORMAT);
			addChild(tfDamage);
			tfDamage.y = -view.height / 2;
			tfDamage.format.color = 0xfa8d6a;
		}
		
		//////////////////////// GETTERs && SETTERS ////////////////////////////////////
		public function get health():int
		{
			return _health;
		}
		
		public function set health(value:int):void
		{
			_health = (value >= 0 ? value : 0);
			tfHealth.text = _health.toString();
			tfHealth.width = tfHealth.text.length * 15;
			tfHealth.alignPivot(Align.RIGHT, Align.TOP);
		}
		
		public function get damage():int
		{
			return _damage;
		}
		
		public function set damage(value:int):void
		{
			_damage = (value >= 0 ? value : 0);
			tfDamage.text = _damage.toString();
			tfDamage.width = tfDamage.text.length * 15;
			tfDamage.alignPivot(Align.LEFT, Align.TOP);
		}
	
	}

}