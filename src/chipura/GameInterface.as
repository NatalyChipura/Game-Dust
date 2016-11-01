package chipura 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.bonuses.BonusFactory;
	import chipura.gamecontent.landscape.LandFactory;
	import chipura.gamecontent.personages.APersonage;
	import chipura.gamecontent.personages.PersonageFactory;
	import chipura.managers.LevelManager;
	import chipura.managers.ServerManager;
	import chipura.User;
	import chipura.screens.AScreen;
	import chipura.screens.ScreenFactory;
	
	import flash.net.SharedObject;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.EnterFrameEvent;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Align;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * Класс интерфейса игры
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class GameInterface extends Sprite 
	{
		public static const TEXT_FIELD:TextField = new TextField(400, 300, "", new TextFormat("Shadow", 26, 0xFFFFFF, Align.LEFT, Align.TOP));
		
		// локальное хранилище данных для сохранения прогресса игры
		private var localStore:SharedObject;
		// экземпляр пользователя
		private var user:User;
		// менеджер запросов к серверу
		private var server:ServerManager;
		// менеджер уровня
		private var level:LevelManager;
		// панель для отображения экранов
		private var panel:ScreenFactory;
		// экземпляр игры (класса процесса игры)
		private var game:GameProcess;
		
		// противники, участвующие в игре
		private var foes:Object;
		// бонусы, участвующие в игре
		private var bonuses:Object;
		// экземпляр игрового контента (некий игровой объект)
		private var content:Sprite;
		
		public function GameInterface() 
		{
			super();
			init();
		}
		
		/**
		 * Инициализация игры. Первый запуск.
		 */
		public function init():void
		{
			// инициализируем подключение к серверу
			server = new ServerManager(AssetsConst.SERVER_URL);
			
			// проверям наличие игрока (впервые ли игра запущена)
			localStore = SharedObject.getLocal(AssetsConst.LOCALSTORE_NAME);
			var isNewPlaer:Boolean = !localStore.data.userid;
			
			// отправляем запрос на сервер для инициализации игры
			if (isNewPlaer) {
				server.sendRequest(AssetsConst.SERVER_REQUEST_INIT, { sid:0 } );
			} else {
				server.sendRequest(AssetsConst.SERVER_REQUEST_INIT, { sid:0, id: localStore.data.userid} );
			}
			server.addEventListener(AssetsConst.EVENT_SERVER_GETRESPONSE, onResponseInit);
		}
		
		/**
		 * Ответ от сервера получен. Производим инициализацию данных игры
		 * @param	e
		 */
		private function onResponseInit(e:Event):void 
		{
			server.removeEventListener(AssetsConst.EVENT_SERVER_GETRESPONSE, onResponseInit);
			var response:Object = server.response;
			
			user = User.getInstance(response.id);
			localStore.data.userid = user.id
			
			trace( "USER_ID", user.id);
			level = new LevelManager();
			levelStart(response);
		}
		
		/**
		 * Формируем уровень по данным от сервера
		 * @param	response - ответ от сервера
		 */
		private function levelStart(response:Object):void 
		{
			// инициализируем данные уровня
			level.map = (response.level as Array);
			level.num = response.level_num;
		//	level.map[0][1] = 4; // добавление ещё одного героя для проверки
			user.health = response.hp;
			user.damage = response.attack;

			// Создаем экран игры
			panel = new ScreenFactory();
			addChild(panel);
			panel.setScreen(ScreenFactory.SCREEN_GAME);

			// Формируем игровое поле
			content = gameContent();
			panel.putContainer(content, AssetsConst.MAP_POS);
			content.addEventListener(EnterFrameEvent.ENTER_FRAME, update);
			
			// добавляем заставку Уровня
			panel.setScreen(ScreenFactory.SCREEN_NEWLEVEL);
			TEXT_FIELD.text = "Уровень " + (level.num+1).toString();
			panel.putContainer(TEXT_FIELD, new Point(stage.stageWidth / 2, stage.stageHeight - 100));

			panel.addEventListener(AssetsConst.EVENT_SCREEN_HIDE, onStartGame);
		}
		
		/**
		 * Размещаем игровые объекты на игровом поле
		 * и возвращаем сформированный спрайт
		 */
		private function gameContent():Sprite
		{
			// Спрайт игрового поля
			var field:Sprite = new Sprite();
			
			// создаем фабрики игрового контента
			var bonus:BonusFactory = new BonusFactory();
			var land:LandFactory = new LandFactory();
			var pers:PersonageFactory = new PersonageFactory();
			
			var cellValue:uint;
			var cell:Point = new Point();
			
			var key:Point;
			
			foes = new Object();
			bonuses = new Object();
			var cntFoe:uint = 0;

		
			// формируем игровое поле
			for (var i:uint = 0; i < AssetsConst.MAP_CELL_CNTROW; i++) {
				for (var j:uint = 0; j < AssetsConst.MAP_CELL_CNTCOL; j++) {
					
					// проверка угловой ячейки. В неё ничего не добавляем.
					if (!isCornerCell(i, j)) {
						
						cellValue = level.map[i][j];
						cell.setTo(j, i);
						
						// выбор контента
						if (BonusFactory.isBonus(cellValue)){
							// Бонусы
							var bonusContent:AContent = bonus.add(cellValue, field, cell);
							key = cell.clone();
							bonuses[key] = bonusContent;
						} else if (LandFactory.isLand(cellValue)) {
							// Ландшафт (стены, выход)
							land.add(cellValue, field, cell);
						} else if (PersonageFactory.isPersonage(cellValue)){
							// Персонажи
							if (cellValue == PersonageFactory.PERS_HERO){
								user.hero = (pers.add(cellValue, field, cell) as APersonage);
							} else {
								var foe:AContent = pers.add(cellValue,  field, cell);
								key = cell.clone();
								foes[key] = (foe as APersonage);
								cntFoe++;
							}
						} 
					}
				}
			}
			
			foes.cnt = cntFoe;
			
			return field;
		}

		/**
		 * Проверяем является ли ячейка угловой
		 * @param	i - индекс строки
		 * @param	j - индекс столбца
		 * @return
		 */
		private function isCornerCell(i:uint,j:uint):Boolean 
		{
			return (i == 0 && j == 0) || (i == 0 && j == AssetsConst.MAP_CELL_CNTCOL-1) || (i == AssetsConst.MAP_CELL_CNTROW-1 && j == 0) || (i == AssetsConst.MAP_CELL_CNTROW-1 && j == AssetsConst.MAP_CELL_CNTCOL-1);
			
		}
		
		/**
		 * Событие начала игры
		 * @param	e
		 */
		private function onStartGame(e:Event):void 
		{
			panel.removeEventListener(AssetsConst.EVENT_SCREEN_HIDE, onStartGame);
			
			// Инициализируем игровой процесс
			game = new GameProcess(user.hero, foes, bonuses);
			addChild(game);
			game.startGame();
			game.addEventListener(AssetsConst.EVENT_LEVEL_COMPLETE, onNextLevel);
			game.addEventListener(AssetsConst.EVENT_LEVEL_FAIL, onLevelFailed);
		}
		
		/**
		 * Событие провала уровня. Предложение начать заново.
		 * @param	e
		 */
		private function onLevelFailed(e:Event):void 
		{
			game.removeEventListener(AssetsConst.EVENT_LEVEL_FAIL, onLevelFailed);
			
			panel.setScreen(ScreenFactory.SCREEN_END);
			TEXT_FIELD.text = "Ты дошёл до " + (level.num+1).toString()+" уровня\nщёлкни мышью,\nчтоб начать заново";
			panel.putContainer(TEXT_FIELD, new Point(stage.stageWidth / 3, stage.stageHeight - 200));
			panel.addEventListener(AssetsConst.EVENT_SCREEN_HIDE, onPlayAgain);
		}
		
		/**
		 * Событие начала игры занов
		 * @param	e
		 */
		private function onPlayAgain(e:Event):void 
		{
			panel.removeEventListener(AssetsConst.EVENT_SCREEN_HIDE, onPlayAgain);
			removeChildren();
			
			if (user) {
				// отправляем запрос серверу о провале игры
				server.sendRequest(AssetsConst.SERVER_REQUEST_LEVELFAIL, { id: user.id } );
				server.addEventListener(AssetsConst.EVENT_SERVER_GETRESPONSE, onResponseLevelComplete);
			} else {
				init();
			}
		}
		
		/**
		 * Событие перехода на следующий уровень
		 * @param	e
		 */
		private function onNextLevel(e:Event):void 
		{
			game.removeEventListener(AssetsConst.EVENT_LEVEL_COMPLETE, onNextLevel);
			
			if (user) {
				// отправка запроса серверу о удачном завершении уровня
				server.sendRequest(AssetsConst.SERVER_REQUEST_LEVELCOMPLETE, { id: user.id, hp: user.hero.health } );
				server.addEventListener(AssetsConst.EVENT_SERVER_GETRESPONSE, onResponseLevelComplete);
			} else {
				init();
			}
		}
		
		/**
		 * Событие получения ответа от сервера после завершения уровня
		 * @param	e
		 */
		private function onResponseLevelComplete(e:Event):void 
		{
			// очищаем контент
			content.removeEventListener(EnterFrameEvent.ENTER_FRAME, update);
			removeChildren();
			panel = null;
			server.removeEventListener(AssetsConst.EVENT_SERVER_GETRESPONSE, onResponseLevelComplete);
			
			// формируем новый уровень по данным с сервера
			levelStart(server.response);
		}
		
		/**
		 * Сортировка экранных объектов (контента) по Y
		 * @param	e
		 */
		private function update(e:EnterFrameEvent):void 
		{
			content.sortChildren(sortY);
		}
				
		private function sortY(obj1:DisplayObject, obj2:DisplayObject):int
		{
			if (obj1.y > obj2.y) return 1;
			if (obj1.y < obj2.y) return -1;
			return 0;
		
		}
		
		
	}

}