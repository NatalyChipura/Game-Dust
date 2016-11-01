package chipura 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.landscape.LandFactory;
	import chipura.gamecontent.personages.APersonage;
	import chipura.gamecontent.personages.PersonageFactory;
	import chipura.gameStates.InitState;
	import chipura.gameStates.IState;
	import chipura.gameStates.TurnFoeState;
	import chipura.gameStates.TurnHeroState;
	import chipura.managers.LevelManager;
	
	import flash.geom.Point;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	/**
	 * Класс управления процессом игры
	 * @author Наталья Чипура (natalychipura@gmail.com)
	 */
	public class GameProcess extends Sprite
	{
		/**
		 * Состояние иницилизации
		 */
		private var _initState:IState;
		/**
		 * Состояние Ход Героя
		 */
		private var _turnHeroState:IState;
		/**
		 * Состояние Ход Противника
		 */
		private var _turnFoeState:IState;
		/**
		 * Текущее состояние
		 */
		private var _state:IState;
		
		/**
		 * Противники в игре
		 */
		private var _foes:Object;
		/**
		 * Бонусы в игре
		 */
		private var _bonuses:Object;
		/**
		 * Герой
		 */
		private var _hero:APersonage;
		
		public function GameProcess(persHero:APersonage, persFoes:Object, bonuses:Object) 
		{
			_initState = new InitState(this);
			_turnHeroState = new TurnHeroState(this);
			_turnFoeState = new TurnFoeState(this);
			state = initState;
			
			_hero = persHero;
			_foes = persFoes;
			_bonuses = bonuses;
		}
		
		/**
		 * Начинаем игру
		 */
		public function startGame():void {
			state.start();
			trace("Start Game");
			if(hero) hero.addEventListener(TouchEvent.TOUCH, onUserTouch);
		}
		
		/**
		 * Событие манипуляций пользователя
		 * @param	e
		 */
		private function onUserTouch(e:TouchEvent):void
		{
			
			var touch:Touch = e.getTouch(hero);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED){
					// ячейка, в которую указал пользователь
					var cell:Point = LevelManager.convertPosToCell(new Point(touch.globalX, touch.globalY),true);
					
					// проверяем, чтобы не было пустого хода
					if(!cell.equals(hero.cell)){
						addEventListener(AssetsConst.EVENT_HERO_TURN_COMPLETE, onHeroTurnComlete);
						// передаем Ход герою
						state.goHero(cell);
					}
				}
			}
 
		}
		
		/**
		 * Событие завершения Хода Героя
		 * @param	e
		 */
		private function onHeroTurnComlete(e:Event):void 
		{
			hero.removeEventListener(AssetsConst.EVENT_HERO_TURN_COMPLETE, onHeroTurnComlete);
		
			// формируем очередь противников
			var listFoes:Vector.<APersonage> = new Vector.<APersonage>();
			for (var key:String in foes) {
				if (foes[key] is APersonage) {
					listFoes.push(foes[key]);
				}
			}
			
			// передаем Ход Противникам
			state.goFoe(listFoes);
				
		}
		
		///////////// GETTERs && SETTERs ////////////////
		
		public function get hero():APersonage 
		{
			return _hero;
		}
		
		public function get foes():Object
		{
			return _foes;
		}		
		
		public function get state():IState 
		{
			return _state;
		}
		
		public function set state(value:IState):void 
		{
			_state = value;
		}
		
		public function get initState():IState 
		{
			return _initState;
		}
		
		public function get turnHeroState():IState 
		{
			return _turnHeroState;
		}

		public function get turnFoeState():IState 
		{
			return _turnFoeState;
		}
		
		public function get bonuses():Object 
		{
			return _bonuses;
		}
	}

}