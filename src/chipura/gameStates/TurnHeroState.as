package chipura.gameStates 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.actions.motions.AMotion;
	import chipura.gamecontent.bonuses.ABonusChangeLive;
	import chipura.gamecontent.bonuses.BonusFactory;
	import chipura.gamecontent.landscape.LandFactory;
	import chipura.gamecontent.personages.APersonage;
	import chipura.gamecontent.personages.PersonageFactory;
	import chipura.GameProcess;
	import chipura.managers.LevelManager;
	
	import flash.geom.Point;

	import starling.events.Event;
	
	/**
	 * Класс состояния Ход Героя
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class TurnHeroState implements IState 
	{
		// экземпляр класса игрового процесса
		private var gameProcess:GameProcess;
		
		public function TurnHeroState(gp:GameProcess) 
		{
			gameProcess = gp;
		}
		
		/* INTERFACE chipura.states.State */
		
		public function start():void 
		{
			// Nothing
		}
		
		/**
		 * Ход героя
		 * @param	cell ячейка куда ходить
		 */
		public function goHero(cell:Point):void 
		{
			var hero:APersonage = gameProcess.hero;
			// добавляем событие завершения хода героя
			hero.addEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onHeroTurnComlete);
			// освобождаем ячейку на карте
			LevelManager.setCellMap(hero.cell, LandFactory.EMPTY);
			
			// выполняем действие движения по направлению к ячейке, которую указал пользователь, и получаем в результате целевую ячейку
			var goalCell:Point = hero.doMove(cell,AMotion.DISTANCE_LONG);
			var value:uint = LevelManager.getCellMap(goalCell);
			
			// в зависимости от значения ячейки производим действия
			if (value == LandFactory.EMPTY) {
				hero.setView(PersonageFactory.VIEW_MOVE);
			} else if (PersonageFactory.isPersonage(value) && value != PersonageFactory.PERS_HERO) {
				// если в ячейке противник, то атакуем
				var foe:APersonage = gameProcess.foes[goalCell];
				hero.doAttack(foe); 
				hero.setView(PersonageFactory.VIEW_ATTACK);
				
				// реакция противника
				if (foe.health > 0) {
					foe.setView(PersonageFactory.VIEW_HURT);
				} else {
					hero.removeEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onHeroTurnComlete);
					foe.setView(PersonageFactory.VIEW_DIE,true);
					foe.addEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onRemoveFoe);
				}
			} else if ( value == BonusFactory.BONUS_HEART) {
				// если бонус, то получаем его действие, и убираем бонус с карты
				hero.setView(PersonageFactory.VIEW_MOVE);
				var bonus:ABonusChangeLive = gameProcess.bonuses[goalCell];
				bonus.doAction(hero);
				delete gameProcess.bonuses[goalCell];
				LevelManager.setCellMap(goalCell, LandFactory.EMPTY);
				bonus.removeFromParent(true);
			} else if (value == LandFactory.EXIT) {
				// если выход, то вызываем событие завершения уровня
				hero.setView(PersonageFactory.VIEW_MOVE);
				gameProcess.dispatchEvent(new Event(AssetsConst.EVENT_LEVEL_COMPLETE));
			}
			
			// передаем ход Противнику
			gameProcess.state = gameProcess.turnFoeState;
		}
		
		/**
		 * Удаление противника в случае победы над ним
		 * @param	e
		 */
		private function onRemoveFoe(e:Event):void 
		{
			var foe:APersonage = (e.target as APersonage);
			foe.removeEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onRemoveFoe);
			
			// устанавливаем ячейку на карте в зависимости от содержимого контейнера противника
			LevelManager.setCellMap(foe.cell, (foe.container)?foe.container.numMap:LandFactory.EMPTY);
			delete gameProcess.foes[foe.cell];
			gameProcess.foes.cnt--;
		
			// завершаем ход героя
			onHeroTurnComlete(null);
			
			// удаляем противника
			foe.remove();
		}
		
		/**
		 * Состояние завершения хода героя
		 * @param	e
		 */
		private function onHeroTurnComlete(e:Event):void 
		{
			gameProcess.hero.removeEventListener(AssetsConst.EVENT_CONTENT_ANIM_COMPLETE, onHeroTurnComlete);
			// устанавливаем ячейку в новое значение
			LevelManager.setCellMap(gameProcess.hero.cell, PersonageFactory.PERS_HERO);
			
			
			gameProcess.dispatchEvent(new Event(AssetsConst.EVENT_HERO_TURN_COMPLETE));
		}
		
		public function goFoe(foes:Vector.<APersonage>):void 
		{
			// Nothing
		}
		
	}

}