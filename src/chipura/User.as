package chipura 
{
	import chipura.assets.AssetsConst;
	import chipura.gamecontent.personages.APersonage;

	/**
	 * Класс пользователя
	 * @author  Наталья Чипура NatalyChipura@gmail.com
	 */
	public class User 
	{
		private static var instance:User;
		/**
		 * Уникальный ключ пользователя ID. Получаем с сервера
		 */
		private static var _id:String;
		/**
		 * персонаж, который назначается пользователю
		 */
		private static var _hero:APersonage;
		/**
		 * Значение здоровья для персонажа пользователя, получаемые с сервера
		 */
		private static var _health:int;
		/**
		 * Значение урона для персонажа пользователя, получаемые с сервера
		 */
		private static var _damage:int;
		
		public function User(singClass:SingletonClass)
		{
			
		}

		public static function getInstance(id:String):User
		{
			if(User.instance == null){
				User.instance = new User(new SingletonClass());
				_id = id;
			} else {
				trace("Sorry, already have a User instantiated");
			}
			
			return User.instance;
		}
		
		public function get id():String 
		{
			return User._id;
		}
		
		public function get hero():APersonage 
		{
			return User._hero;
		}
		
		public function set hero(value:APersonage):void 
		{
			User._hero = value;
			User._hero.health = User._health;
			User._hero.damage = User._damage;
		}
		
		public function set health(value:int):void 
		{
			_health = value;
		}
		
		public function set damage(value:int):void 
		{
			_damage = value;
		}
	}
}

class SingletonClass {
	public function SingletonClass() {
		trace("User class was created");
	}
}