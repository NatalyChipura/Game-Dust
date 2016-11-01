package chipura.gamecontent.landscape 
{
	import chipura.gamecontent.AContentCreator;
	import chipura.gamecontent.AContent;
	import flash.geom.Point;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * Класс Фабрика Ландшафта
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class LandFactory extends AContentCreator 
	{
		// конфиг графики ландшафта
		private static var configLands:XMLList = configContent.Content.Landscape;
		
		// константы типов ландшафта
		public static const LET_WALL:uint = configLands.Wall.@numMap;
		public static const EXIT:uint = configLands.Exit.@numMap;
		public static const EMPTY:uint = configLands.Empty.@numMap;
		
		public static const LAND_ALL:Vector.<uint> = Vector.<uint>([LET_WALL, EXIT,EMPTY]);
		
		public function LandFactory() 
		{
			super();
		}
		
		/**
		 * Создать экземпляр ландшафта
		 * @param	type тип ландшафта
		 * @return  экземпляр ландшафта
		 */
		override public function createObject(type:uint):AContent
		{
		
			switch(type){
				case LET_WALL: {
					return new Wall(configLands.Wall);
				} break;
				case EXIT: {
					return new Exit(configLands.Exit);
				} break;
				case EMPTY: {
					return null;
				} break;
				default: {
					throw new Error("Invalid Screen set");
					return null;
				}
			}
		}
		
		/**
		 * Определяет относится ли данный тип контента к ландшафту
		 * @param	type тип контента
		 * @return  true если это ландшафт, иначе false
		 */
		public static function isLand(type:uint):Boolean {
			return LAND_ALL.indexOf(type) != -1;
		}
	
	}

}