package chipura.gamecontent.actions.attacks 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.personages.APersonage;
	import starling.events.Event;

	/**
	 * Класс Атаки противника, который распологается рядом
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class AttackFoeNear implements IAttack 
	{
		
		public function AttackFoeNear() 
		{
			
		}
		
		/* INTERFACE chipura.gamecontent.personages.actions.attacks.IAttack */
		/**
		 * Удар по врагу, который находится рядом
		 * @param	persA - Атакующий
		 * @param	persB - Принимающий удар
		 */
		public function execute(persA:AContent, persB:AContent):void 
		{
			(persB as APersonage).health -= (persA  as APersonage).damage;
			if (persA.x < persB.x) {
				persB.mirrorX(1);
			} else {
				persB.mirrorX(-1);
			}
			if ((persB as APersonage).health == 0) {
				persB.dispatchEvent(new Event(AssetsConst.EVENT_PERSONAGE_DIE));
			}
		}
		
	}

}