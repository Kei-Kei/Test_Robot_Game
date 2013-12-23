package{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	import fileLoader;
	
	public class xmlLoader extends fileLoader{
		public function xmlLoader(){
		}
		public function retData():XML{
			return new XML( loader.data );
		}
	}
}