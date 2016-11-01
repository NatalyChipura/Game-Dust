package chipura.gamecontent 
{
	import chipura.assets.AssetsConst;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	
	/**
	 * Абстрактный класс Фабрики Контента
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class AContentCreator extends Sprite 
	{
		// конфиг графики контента
		protected static var configContent:XML = AssetsConst.embeds.getXml("ConfigContent");
		
		public function AContentCreator() 
		{
			super();
			
		}
		
		/**
		 * Добавление контента на target 
		 * @param	type Тип контента
		 * @param	target экранный объект для размещения
		 * @param	cell ячейка, в которую поместить
		 * @return
		 */
		public function add(type:uint,target:DisplayObjectContainer = null,cell:Point = null):AContent {
			var gameObj:AContent = createObject(type);	
			
			if(gameObj){
				if(target){
					target.addChild(gameObj);
				} else {
					addChild(gameObj);
				}
				gameObj.putTo(cell?cell:AssetsConst.POINT_00);
			}
			
			return gameObj;
		}
		
		// Абстрактный метод (должен быть замещен в подклассе)
		public function createObject(type:uint):AContent
		{
			throw new IllegalOperationError("Abstract method: must be overridden in a subclass");
			return null;
		}
		
	}

}