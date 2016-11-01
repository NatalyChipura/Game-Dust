package chipura.gamecontent.landscape 
{
	import chipura.gamecontent.AContent;
	
	/**
	 * Класс контента Стена
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	internal class Wall extends AContent 
	{
		public function Wall(config:XMLList,num:uint=0) 
		{
			super(config);
			// выбор случайного вида стены
			gotoAndStop(Math.floor(Math.random()*config.TextureAct.@cntFrame));
		}
		
	}

}