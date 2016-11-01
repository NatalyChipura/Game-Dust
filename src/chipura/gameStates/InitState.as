package chipura.gameStates 
{
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.personages.APersonage;
	import chipura.GameProcess;
	import flash.geom.Point;
	/**
	 * Класс состояния Инициализации
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class InitState implements IState 
	{
		// экземпляр класса игрового процесса
		private var gameProcess:GameProcess;
		
		public function InitState(gp:GameProcess) 
		{
			gameProcess = gp;
		}
		
		/* INTERFACE chipura.states.State */
		/**
		 * Начинаем игру
		 */
		public function start():void 
		{
			// устанавливаем состояние в Ход Игрока
			gameProcess.state = gameProcess.turnHeroState;
		}
		
		public function goHero(cell:Point):void 
		{
			// Nothing
		}
		
		public function goFoe(foes:Vector.<APersonage>):void 
		{
			
		}
		
		public function end():void 
		{
			
		}
		
	}

}