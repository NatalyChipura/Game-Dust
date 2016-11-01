package chipura.gamecontent.bonuses 
{
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.actions.bonusAction.AddHealth;
	import chipura.gamecontent.actions.bonusAction.IBonusAction;
	import chipura.gamecontent.personages.APersonage;
	/**
	 * Абстрактный класс бонусов меняющих значение здоровья
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class ABonusChangeLive extends AContent
	{
		// количество на сколько менять здоровье
		protected var amountHP:int;
		// действие бонуса
		protected var action:IBonusAction;
		
		/**
		 * Конструктор класса Бонус изменения показателя жизни 
		 * @param	config конфигурационная XML с данными о текстурах
		 * @param	количество здоровья
		 */
		public function ABonusChangeLive(config:XMLList,cntHp:int) 
		{
			super(config);
			amountHP = cntHp;
			// действие добавление жизни
			action = new AddHealth();
		}
		
		/**
		 * применить действие бонуса
		 * @param	pers Персонаж, на которого воздействовать
		 */ 
		public function doAction(pers:APersonage):void {
			action.apply(pers, amountHP);
		}
		
		/**
		 * Установить новое действие
		 * @param	newAction экземпляр класса Действия Бонуса
		 */
		public function setAction(newAction:IBonusAction):void {
			action = newAction;
		}
		
	}

}