package chipura.assets 
{
	import chipura.gamecontent.actions.motions.AMotion;
	import flash.geom.Point;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author 
	 */
	public class AssetsConst 
	{
		/////////////////// FOE ////////////////////////////////////////////////////
		public static const FOE_HOWMOVE:uint = AMotion.DISTANCE_RAND; // DISTANCE_LONG or DISTANCE_SHORT or DISTANCE_RAND
		
		/////////////////// SERVER //////////////////////////////////////////////////
		public static const SERVER_URL:String = "http://test.playmonstertoons.com";
		public static const SERVER_REQUEST_INIT:String = "init";
		public static const SERVER_REQUEST_LEVELCOMPLETE:String = "level_complete";
		public static const SERVER_REQUEST_LEVELFAIL:String = "level_failed";
		
		/////////////////// LOCAL STORE ////////////////////////////////////////////
		public static const LOCALSTORE_NAME:String = "chipuraGameDust";
		
		/////////////////// SCREENs /////////////////////////////////////////////////
		public static const SPLASH_TIME_SHOW:uint = 0;
		public static const SCREEN_TIMESHOW:uint = 1;
		public static const SCREEN_SHOW_FOREVER:uint = 0;
		
		/////////////////// EVENTs //////////////////////////////////////////////////
		public static const EVENT_SERVER_GETRESPONSE:String = "ServerRequestComplete";
		
		public static const EVENT_SCREEN_HIDE:String = "ScreenHide";
		
		public static const EVENT_ACT_MOTION_COMPLETE:String = "MotionComplete";
		
		public static const EVENT_LEVEL_COMPLETE:String = "EvtLevelComplete";
		public static const EVENT_LEVEL_FAIL:String = "EvtLevelFail";
		
		public static const EVENT_CONTENT_ANIM_COMPLETE:String = "ContentAnimComplete";
		
		public static const EVENT_HERO_TURN_COMPLETE:String = "HeroTurnComplete";
		
		public static const EVENT_PERSONAGE_DIE:String = "PersonageDie";
		
		/////////////////// MAP /////////////////////////////////////////////////////
		public static const MAP_POS:Point = new Point(87, 33);
		public static const MAP_CELL_WIDTH:uint = 70;
		public static const MAP_CELL_HEIGHT:uint = 64;
		public static const MAP_CELL_CNTCOL:uint = 9;
		public static const MAP_CELL_CNTROW:uint = 9;
		
		public static const BONUS_HEART_CNTHP:uint = 1;
		
		public static const POINT_00:Point = new Point(0, 0);

		
		/////////////////// FONTs ////////////////////////////////////////////////////
		[Embed(source="font/shadow_regular.ttf", embedAsCFF="false", fontFamily="Shadow")]
		private static const FontShadowRegular:Class;	
		
		
		////////////////// TEXTUREs EMBEDs //////////////////////////////////////////
		[Embed(source="img/SplashScreen.png")]
		public static const TextureSplashScreen:Class;
		
		[Embed(source="img/fonScreen.png")]
		public static const TextureFonScreen:Class;
		
		[Embed(source="img/newLevel.png")]
		public static const TextureTitleNewLevel:Class;
		
		[Embed(source="img/gameOver.png")]
		public static const TextureTitleFailLevel:Class;
		
		[Embed(source="img/gameFloor.png")]
		public static const ScreenGameFloor:Class;
		
		[Embed(source="img/gameScreenEffect.png")]
		public static const ScreenGameEffect:Class;
		
		////////////////// ATLAS TEXTUREs //////////////////////////////////////////
		
		// Config Graphics
		[Embed(source="xml/configGraphics.xml", mimeType="application/octet-stream")]
		public static const ConfigContent:Class;
		
		// Embed the Atlas XML
		[Embed(source="xml/atlasGO.xml", mimeType="application/octet-stream")]
		public static const atlasGameObjXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source="img/atlasGO.png")]
		public static const atlasGameObjTexture:Class;
		
		private static var _atlas:TextureAtlas;

		private static var _embeds:AssetManager;
		
		static public function get embeds():AssetManager 
		{
			return _embeds;
		}
		
		static public function set embeds(value:AssetManager):void 
		{
			if(!_embeds){
				_embeds = value;
			} else {
				trace("AssetManager already exists.");
			}
		}
		
		static public function get atlas():TextureAtlas 
		{
			return _atlas;
		}
		
		static public function set atlas(value:TextureAtlas):void 
		{
			if (!_atlas) {
				_atlas = value;
			} else {
				trace("AssetManager already exists.");
			}
		}
		
		
		
	}

}