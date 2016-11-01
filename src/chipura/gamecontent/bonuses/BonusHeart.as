package chipura.gamecontent.bonuses 
{
	import chipura.assets.AssetsConst;

	/**
	 * Класс контента Бонус Сердце
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	internal class BonusHeart extends ABonusChangeLive
	{
		
		public function BonusHeart(config:XMLList) 
		{
			super(config,AssetsConst.BONUS_HEART_CNTHP);
		}
		
	}

}