package chipura.gamecontent.actions.bonusAction 
{
	import chipura.gamecontent.personages.APersonage;
	/**
	 * Класс Действия добавления здоровья
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class AddHealth implements IBonusAction 
	{
		
		public function AddHealth() 
		{
			
		}
		
		/* INTERFACE chipura.gamecontent.actions.bonusAction.IBonusAction */
		
		/**
		 * Применить действие бонуса
		 * @param	pers персонаж, на которого воздействуем
		 * @param	cnt количество воздействия
		 */
		public function apply(pers:APersonage, cnt:uint):void 
		{
			pers.health += cnt;
		}
		
	}

}