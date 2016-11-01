package chipura.gamecontent.actions.attacks 
{
	import chipura.gamecontent.AContent;

	/**
	 * Интерфейс действия Атаки
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public interface IAttack 
	{
		/**
		 * Применить атаку
		 * @param	persA персонаж, который атакует
		 * @param	persB персонаж, который принимает атаку
		 */
		function execute(persA:AContent,persB:AContent):void;
	}

}