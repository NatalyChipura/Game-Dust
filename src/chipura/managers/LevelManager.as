package chipura.managers 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.landscape.LandFactory;
	import flash.geom.Point;
	
	/**
	 * Класс управления уровнями
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	public class LevelManager 
	{
		/**
		 * Карта уровня
		 */
		private static var _map:Array;
		/**
		 * Номер уровня
		 */
		private var _num:int;
		
		public function LevelManager() 
		{
		
		}
		
		/**
		 * Преобразовать позицию в ячейку
		 * @param	pos позиция (x,y)
		 * @param	isGlobal глобальные ли координаты или координаты карты
		 * @return  ячейка (i,j)
		 */
		public static function convertPosToCell(pos:Point,isGlobal:Boolean = false):Point {
			var cell:Point = isGlobal?pos.subtract(AssetsConst.MAP_POS):pos.clone();
			cell.setTo(Math.round((cell.x - AssetsConst.MAP_CELL_WIDTH / 2) / AssetsConst.MAP_CELL_WIDTH), Math.round((cell.y - AssetsConst.MAP_CELL_HEIGHT / 2) / AssetsConst.MAP_CELL_HEIGHT));
			return cell;
		}
		
		/**
		 * Преобразовать ячейку в позицию
		 * @param	cell ячейка (i,j)
		 * @param	isGlobal глобальные ли координаты или координаты карты
		 * @return  позиция (x,y)
		 */
		public static function convertCellToPos(cell:Point,isGlobal:Boolean = false):Point {
			var pos:Point = isGlobal?cell.subtract(AssetsConst.MAP_POS):cell.clone();
			pos.setTo(AssetsConst.MAP_CELL_WIDTH * pos.x + AssetsConst.MAP_CELL_WIDTH / 2, AssetsConst.MAP_CELL_HEIGHT * pos.y +AssetsConst.MAP_CELL_HEIGHT / 2);
			return pos;
		}
		
		/**
		 * Установить значение ячейки на карте
		 * @param	cell ячейка
		 * @param	value значение
		 */
		public static function setCellMap(cell:Point, value:uint):void {
			_map[uint(cell.y)][uint(cell.x)] = value;
		}
		
		/**
		 * Получить значение ячейки
		 * @param	cell ячейка
		 * @return  значение на карте
		 */
		public static function getCellMap(cell:Point):uint
		{
			var value:uint;
			if (cell.x < 0 || cell.y < 0 || cell.x >= AssetsConst.MAP_CELL_CNTCOL || cell.y >= AssetsConst.MAP_CELL_CNTROW) {
			 	value = LandFactory.LET_WALL;
			} else {
				value = _map[cell.y][cell.x];
			}
			return value;
		}
		
		//////////////// GETTERs & SETTERs /////////////////////
		
		public function get map():Array
		{
			return _map;
		}
		
		public function set map(value:Array):void 
		{
			_map = value;
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = (value>=0?value:0);
		}
		
	
		
	}

}