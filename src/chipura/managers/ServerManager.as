package chipura.managers 
{
	import chipura.assets.AssetsConst;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import starling.events.EventDispatcher;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLRequestDefaults;
	
	/**
	 * Класс запросов к серверу
	 * @author Наталья Чипура natalychipura@gmail.com
	 */
	public class ServerManager extends EventDispatcher
	{
		// запрос
		private var request:URLRequest;
		// загрузчик
		private var loader:URLLoader;
		// Путь к серверу
		private var _url:String;
		// Метод отправки GET
		private var _method:String;
		/**
		 * Ответ от сервера
		 */
		private var _response:Object;

		public function ServerManager(url:String,method:String = URLRequestMethod.GET) 
		{
			_url = url;
			_method = method;
			initRequest();
		}
		
		/**
		 * Инициализация запроса
		 */
		private function initRequest():void{
			
			request = new URLRequest(); 
			request.method = _method;

			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatusHandler);
		}
		
		/**
		 * Отправка запроса
		 * @param	subURL подадрес пути к серверу
		 * @param	param передаваемые параметры
		 */
		public function sendRequest(subURL:String, param:Object):void {
			try {
				var variables:URLVariables = new URLVariables(); 
				for (var key:String in param) {
					variables[key] = param[key];
				}
				request.data = variables;
			} catch (error:Error){
				throw new IllegalOperationError("Check out parameters. ",error.errorID);
			}	
		
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			request.url = _url + "/" + subURL;
			try	{
				loader.load(request);
			}
			catch (error:Error)
			{
				throw new IllegalOperationError("Send request to Server was failed",error.errorID);
			}
		}
		
		/**
		 * Получение данных от сервера
		 * @param	e
		 */
		private function onComplete(e:flash.events.Event):void
		{
			// сохраняем полученные данные в response
			_response = JSON.parse(e.target.data);
			dispatchEvent(new starling.events.Event(AssetsConst.EVENT_SERVER_GETRESPONSE));
		}
		
		protected function onIOError(e:IOErrorEvent):void
		{
			trace(e);
			throw new IllegalOperationError("Get data from Server was fail. ", e.errorID);
		}
		
		
		private function onStatusHandler(e:Event):void
		{
			trace(e);
		}
		
		public function get response():Object 
		{
			if (!_response) {
				throw new IllegalOperationError("Response from the server has not yet received");	
			} 
			
			return _response;
			
		}
		
		
	}

}