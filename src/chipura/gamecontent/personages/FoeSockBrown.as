package chipura.gamecontent.personages 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.actions.attacks.AttackFoeNear;
	import chipura.gamecontent.actions.motions.MoveOneCell;
	import starling.core.Starling;

	/**
	 * Класс противника Коричневый носок
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	internal class FoeSockBrown extends APersonage 
	{
		// значение здоровья
		private const VALUE_HP:uint = 6;
		// значение урона
		private const VALUE_DAMAGE:uint = 3;
		
		/**
		 * Конструктор класса Коричневый носок 
		 * @param	config конфигурационная XML с данными о текстурах
		 */
		public function FoeSockBrown(config:XMLList) 
		{
			super(config);
			health = VALUE_HP;
			damage = VALUE_DAMAGE;
			
			// устанавливаем движение на одну ячейку
			motion = new MoveOneCell();
			// устанавливаем атаку противника, который рядом
			attack = new AttackFoeNear();
			
			// устанавливаем вид по умолчанию Покачивание
			setView(PersonageFactory.VIEW_IDLE,true);
		}
		
	}

}