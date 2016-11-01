package chipura.screens 
{
	/**
	 * Класс фабрики экранов
	 * @author Наталья Чипура NatalyChipura@gmail.com
	 */
	public class ScreenFactory extends AScreenCreator 
	{
		public static const SCREEN_SPLASH:String = "SCSplash";
		public static const SCREEN_GAME:String = "SCgame";
		public static const SCREEN_NEWLEVEL:String = "SCnewlevel";
		public static const SCREEN_END:String = "SCfinallevel";
		
		public function ScreenFactory() 
		{
			super();
		}
		
		/**
		 * Создать экрна
		 * @param	type тип экрана
		 * @return экземпляр экрана
		 */
		override protected function createScreen(type:String):AScreen
		{
			switch(type){
				case SCREEN_GAME: {
					return new ScreenGame();
				} break;
				case SCREEN_NEWLEVEL: {
					return new ScreenNewLevel();
				} break;
				case SCREEN_END: {
					return new ScreenEnd();
				} break;
				case SCREEN_SPLASH: {
					return new ScreenSplash();
				} break;
				default: {
					throw new Error("Invalid Screen set");
					return null;
				}
			}
		}
		
	}

}