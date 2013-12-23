package{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	public class fileLoader extends Sprite{
		
		public var Loaded:int;
		public var Total:int;
		public var Complete:Boolean;
		
		protected var loader:URLLoader = new URLLoader();
		
		public function fileLoader(){
		}
		
		public function Load( filename:String ){
			loader.addEventListener(Event.COMPLETE, loadComplete);
			loader.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader.load( new URLRequest( filename ) );
		}
		
        private function loadProgress(event:ProgressEvent):void {
			Loaded = event.bytesLoaded;
			Total = event.bytesTotal;
		}
		
		private function loadComplete(event:Event):void {
            Complete = true;
			loader.removeEventListener(Event.COMPLETE, loadComplete);
			loader.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
        }
	}
}