package chipura.gamecontent.actions.bonusAction 
{
	import chipura.gamecontent.personages.APersonage;
	/**
	 * Интефейс Действия бонуса
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public interface IBonusAction 
	{
		/**
		 * Применить действие бонуса
		 * @param	pers персонаж, на которого воздействуем
		 * @param	cnt количество воздействия
		 */
		function apply(pers:APersonage, cnt:uint):void;
	}

}