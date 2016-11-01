package chipura.gamecontent.actions.motions 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.bonuses.BonusFactory;
	import chipura.gamecontent.landscape.LandFactory;

	import chipura.managers.LevelManager;
	import flash.geom.Point;
	
	/**
	 * Класс движения на одну ячейку
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	public class MoveOneCell extends AMotion 
	{
		
		public function MoveOneCell() 
		{
			super();
			
		}
		
		/**
		 * Выполнить движение
		 * @param	obj контент, который совершает движение
		 * @param	cell ячейка, в которую движется объект
		 * @param	howMove алгоритм движения, задается константами  
		 * @return  целевая ячейка, которую определили для перемещения
		 */
		override public function execute(pers:AContent,cell:Point, howMove:uint):Point{
			
			// определяем вектор направления, учитывая возможность перемещения на одну ячейку
			var vector:Point = scaleToNCell(pers.cell.subtract(cell), howMove, 1);
			var goalCell:Point;
			trace(pers.cell.subtract(cell), vector);
			var value:uint;
			// определяем целевую ячейку в нужном направлении
			if (Math.abs(vector.x) != Math.abs(vector.y)) {
				goalCell = pers.cell.subtract(vector);
				// определяем содержимое целевой ячейки
				value = LevelManager.getCellMap(goalCell);	
			} else {
				// если направление по Х и Y одинаковое, то предпочитаем ячейку без препятствия
				var checkVector:Point = new Point(vector.x, 0); 
				goalCell = pers.cell.subtract(checkVector);
				value = LevelManager.getCellMap(goalCell);
				
				if (value == LandFactory.LET_WALL) {
					checkVector = new Point(0, vector.y); 
					goalCell = pers.cell.subtract(checkVector);
					value = LevelManager.getCellMap(goalCell);
				
				}
			}
				
			// отразить персонажа в соответствии с направлением
			pers.mirrorX(vector.x);
	
			// если ячейка пустая, сразу перемещаем туда персонажа
			if (value == LandFactory.EMPTY || BonusFactory.isBonus(value)) {
				tweenToCell(pers, goalCell, 0.5);
			} 
					
			// сохраняем и возвращаем ячейку со значение на случай, если ячейка не пустая
			return goalCell;
		}
		
		
		
	}

}