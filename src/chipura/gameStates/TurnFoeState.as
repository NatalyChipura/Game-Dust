package chipura.gameStates 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.AContent;
	import chipura.gamecontent.actions.motions.AMotion;
	import chipura.gamecontent.bonuses.BonusFactory;
	import chipura.gamecontent.landscape.LandFactory;
	import chipura.gamecontent.personages.APersonage;
	import chipura.gamecontent.personages.PersonageFactory;
	import chipura.GameProcess;
	import chipura.managers.LevelManager;

	import starling.core.Starling;
	import starling.events.Event;

	import flash.geom.Point;

	/**
	 * Класс состояния Ход Противника
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class TurnFoeState implements IState 
	{
		// экземпляр класса игрового процесса
		private var gameProcess:GameProcess;
		// список противников, которые находятся в очереди на Ход
		private var goneFoes:Vector.<APersonage>;
		
		
		public function TurnFoeState(gp:GameProcess) 
		{
			gameProcess = gp;
		}
		
		/* INTERFACE chipura.states.IState */
		
		public function start():void 
		{
			// Nothing
		}
		
		/**
		 * Ход героя. Обрабатывается только если нет больше противников. Иначе Герой не может делать ход, пока находимся в состоянии Ход Противника.
		 * @param	cell ячейка куда ходить
		 */
		public function goHero(cell:Point):void 
		{
			if (gameProcess.foes.cnt == 0) {
				// если противников не осталось передаем ход герою
				gameProcess.state = gameProcess.turnHeroState;
				gameProcess.state.goHero(cell);
			}
			
		}
		
		/**
		 * Ход противника.
		 * @param	foes список противников, которые должны походить
		 */
		public function goFoe(foes:Vector.<APersonage>):void 
		{
			goneFoes = foes;
			
			if(goneFoes.length>0){
				
				var foe:APersonage = goneFoes.pop();
				var hero:APersonage = gameProcess.hero;
				var goalCell:Point;
				
				// удаляем противника из списка противников игры для перезаписи значения ячейки противника
				delete gameProcess.foes[foe.cell];
				
				// добавляем событие для обработки завершения хода противника
				foe.addEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onFoeTurnComlete);
					
				// освобождаем ячейку на карте
				LevelManager.setCellMap(foe.cell, LandFactory.EMPTY);
					
				// выполняем действие движения по направлению к герою и получаем в результате целевую ячейку
				goalCell = foe.doMove(hero.cell, AssetsConst.FOE_HOWMOVE);
					
				var value:uint = LevelManager.getCellMap(goalCell);
				
				// в зависимости от значения ячейки производим действия
				if (LandFactory.isLand(value)) {
					// меняем вид на движение	
					foe.setView(PersonageFactory.VIEW_MOVE); 
				} else if (PersonageFactory.isPersonage(value) ) {
					
					if(value == PersonageFactory.PERS_HERO){
						// если в ячейке персонаж, то атакуем
						foe.doAttack(hero);
						
						// реакция персонажа
						if (hero.health > 0) {
							hero.setView(PersonageFactory.VIEW_HURT);
						} else {
							hero.setView(PersonageFactory.VIEW_DIE,true);
							foe.removeEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onFoeTurnComlete);
							hero.addEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onRemoveHero);
						}
						foe.setView(PersonageFactory.VIEW_ATTACK);
						
					} else {
						foe.setView(PersonageFactory.VIEW_MOVE);
					}
				} else if ( value == BonusFactory.BONUS_HEART) {
					// если бонус в ячейке, то сохраняем его в контейнер противника для последующего востановления
					foe.setView(PersonageFactory.VIEW_MOVE);
					foe.container = gameProcess.bonuses[goalCell];
				} 

			} else {
				// меняем состояние на Ход Героя, если противников больше не осталось
				gameProcess.state = gameProcess.turnHeroState;
			}
			

		}
		
		/**
		 * Состояние удаления героя, в случе его гибели
		 * @param	e
		 */
		private function onRemoveHero(e:Event):void 
		{
			var hero:APersonage = (e.target as APersonage);
			hero.removeEventListeners();
			// меняем состояние игрового процесса на состояние инициализации
			gameProcess.state = gameProcess.initState;
			// небольшая задержка для плавного завершения
			Starling.juggler.delayCall( end, 1); 
			
		}
		
		public function end():void 
		{
			// вызываем событие провала уровня
			gameProcess.dispatchEvent(new Event(AssetsConst.EVENT_LEVEL_FAIL));
		}
		
		/**
		 * Состояние завершения Хода Противника
		 * @param	e
		 */
		private function onFoeTurnComlete(e:Event):void 
		{
			var foe:APersonage = (e.target as APersonage);
			foe.removeEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onFoeTurnComlete);
			
			// устанавливаем на карте новое положение противника
			LevelManager.setCellMap(foe.cell, foe.numMap);
			// добавляем новое значение в список противников игрового процесса
			gameProcess.foes[foe.cell] = foe;
			
			// восстанавливаем бонус
			var bonus:AContent = foe.container;
			if (bonus && !foe.cell.equals(bonus.cell)) {
				LevelManager.setCellMap(bonus.cell, bonus.numMap);
				foe.container = null;
			}

			// проверка завершения хода всеми противниками в очереди
			completeTurnAllFoes();

		}
		
		private function completeTurnAllFoes():void 
		{
			if (goneFoes.length == 0) {
				// передаем ход Герою
				gameProcess.state = gameProcess.turnHeroState;
			} else {
				// ход следующего противника
				goFoe(goneFoes);
			}
		}
		
		
	}

}