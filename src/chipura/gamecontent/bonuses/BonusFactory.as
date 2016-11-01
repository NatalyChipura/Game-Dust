package chipura.gamecontent.bonuses 
{
	import chipura.gamecontent.AContentCreator;
	import chipura.gamecontent.AContent;
	import flash.geom.Point;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * Класс Фабрика бонусов
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class BonusFactory extends AContentCreator 
	{
		// конфиг графики бонусов
		private static var configBonuses:XMLList = configContent.Content.Bonuses;
		
		// константы типов бонусов
		public static const BONUS_HEART:uint = configBonuses.Heart.@numMap;
		public static const BONUS_ALL:Vector.<uint> = Vector.<uint>([BONUS_HEART]);
		
		public function BonusFactory() 
		{
			super();
			
		}

		/**
		 * Создать экземпляр бонуса
		 * @param	type тип бонуса
		 * @return  экземпляр бонуса
		 */
		override public function createObject(type:uint):AContent
		{
			switch(type){
				case BONUS_HEART: {
					return new BonusHeart(configBonuses.Heart);
				} break;
				default: {
					throw new Error("Invalid Screen set");
					return null;
				}
			}
		}
	
		/**
		 * Определяет является ли данный тип контента бонусом
		 * @param	type тип контента
		 * @return  true если это бонус, иначе false
		 */
		public static function isBonus(type:uint):Boolean {
			return BONUS_ALL.indexOf(type) != -1;
		}
	}

}