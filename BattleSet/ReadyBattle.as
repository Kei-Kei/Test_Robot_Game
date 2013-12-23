package BattleSet{
	import flash.display.Sprite;
	import flash.utils.*;
	import MyText;
	
	public class ReadyBattle extends Sprite{
		public var mc_ReadyBar:ReadyBar = new ReadyBar();
		public var text_Count:MyText = new MyText(-3,-8,"CENTER");
		
		public var StartCount:int;
		
		public function ReadyBattle(){
			this.addChild(mc_ReadyBar);
			mc_ReadyBar.alpha = 0.8;
			this.addChild(text_Count);
			text_Count.dispText( "Ready!" );
			StartCount = getTimer();
		}
		public function CountDown():Boolean{
			var time = getTimer();
			if( time - StartCount > 4000){
				text_Count.dispText( "Go!" );
				mc_ReadyBar.scaleX = 0;
				return true;
			}else if( time - StartCount <= 1000) text_Count.dispText( "Ready!" );
			else text_Count.dispText( "---"+ (int)(5-(time - StartCount)/1000) +"---" );
			
			mc_ReadyBar.scaleX = (4000 - time + StartCount)/4000;
			return false;
		}
	}
}