package chipura.gameStates 
{
	import chipura.gamecontent.personages.APersonage;
	import chipura.GameProcess;
	import flash.geom.Point;
	
	/**
	 * Интерфейс Состояний игрового процесса
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public interface IState 
	{
		/**
		 * Старт игры
		 */	
		function start():void;
		/**
		 * Передаем право хода герою
		 * @param	cell - ячейка куда ходить
		 */
		function goHero(cell:Point):void;
		/**
		 * Передаем право хода противникам
		 * @param	foes список противников
		 */
		function goFoe(foes:Vector.<APersonage>):void;
	}

}