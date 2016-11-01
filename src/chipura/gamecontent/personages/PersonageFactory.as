package chipura.gamecontent.personages 
{
	import chipura.gamecontent.AContentCreator;
	import chipura.gamecontent.AContent;
	import flash.geom.Point;

	
	/**
	 * Класс Фабрика Персонажей
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class PersonageFactory extends AContentCreator 
	{
		// конфиг графики персонажей
		private static var configPers:XMLList = configContent.Content.Personages;
		
		// константы типов персонажей
		public static const PERS_HERO:uint = configPers.Hero.@numMap;
		public static const PERS_FOE_SOCK_GREEN:uint = configPers.SockGreen.@numMap;
		public static const PERS_FOE_SOCK_BROWN:uint = configPers.SockBrown.@numMap;
		public static const PERS_ALL:Vector.<uint> = Vector.<uint>([PERS_HERO, PERS_FOE_SOCK_GREEN, PERS_FOE_SOCK_BROWN]);
		
		// константы видов (анимаций) персонажей
		public static const VIEW_MOVE:String = "Move";
		public static const VIEW_IDLE:String = "Idle";
		public static const VIEW_HURT:String = "Hurt";
		public static const VIEW_ATTACK:String = "Attack";
		public static const VIEW_DIE:String = "Die";
		
		public function PersonageFactory() 
		{
			super();
		}
		
		/**
		 * Создать персонажа
		 * @param	type тип персонажа
		 * @return  экземпляр персонажа
		 */
		override public function createObject(type:uint):AContent
		{
			switch(type){
				case PERS_HERO: {
					return new Hero(configPers.Hero);
				} break;
				case PERS_FOE_SOCK_GREEN: {
					return new FoeSockGreen(configPers.SockGreen);
				} break;
				case PERS_FOE_SOCK_BROWN: {
					return new FoeSockBrown(configPers.SockBrown);
				} break;
				default: {
					throw new Error("Invalid Screen set");
					return null;
				}
			}
		}
		
		/**
		 * Определяет является ли данный тип контента персонажем
		 * @param	type тип контента
		 * @return  true если это персонаж, иначе false
		 */
		public static function isPersonage(type:uint):Boolean {
			return PERS_ALL.indexOf(type) != -1;
		}
	}

}