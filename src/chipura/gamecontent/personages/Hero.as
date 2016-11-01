package chipura.gamecontent.personages 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.actions.attacks.AttackFoeNear;
	import chipura.gamecontent.actions.motions.AMotion;
	import chipura.gamecontent.actions.motions.MoveOneCell;
	import flash.geom.Point;

	/**
	 * Класс Героя
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	internal class Hero extends APersonage 
	{
		// координаты коррекции для выравнивания текстур
		private const ptCorrect:Point = new Point(0,5);
		
		public function Hero(config:XMLList) 
		{
			super(config);

			// устанавливаем движение на одну ячейку
			motion = new MoveOneCell();
			// устанавливаем атаку противника, который рядом
			attack = new AttackFoeNear();
			// устанавливаем вид по умолчанию Покачивание
			setView(PersonageFactory.VIEW_IDLE, true);
			
		}
		
		override public function doMove(cell:Point, howMove:uint):Point 
		{
			// всегда двигаться по алгоритму длинного пути (за движение пользователя)
			return super.doMove(cell, AMotion.DISTANCE_LONG);
		}
		
		override public function set position(value:Point):void 
		{
			value.add(ptCorrect);
			super.position = value;
			y += ptCorrect.y;
		}	
		
		override public function set cell(value:Point):void 
		{
			super.cell = value;
			position.y += ptCorrect.y;
			y += ptCorrect.y;
		}	

		
	}

}