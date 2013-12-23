package BattleSet{
	import flash.display.Sprite;
	import flash.utils.*;
	import MyText;
	
	public class EndBattle extends Sprite{
		public var mc_ReadyBar:Sprite = new ReadyBar();
		public var text_Count:Sprite = new MyText(-3,-8,"CENTER");
		
		public var StartCount:int;
		
		public function EndBattle(){
			this.addChild(mc_ReadyBar);
			mc_ReadyBar.alpha = 0.8;
			this.addChild(text_Count);
			text_Count.dispText( "Battle End" );
			text_Count.visible = false;
			StartCount = getTimer();
		}
		public function CountDown():Boolean{
			var time = getTimer() - StartCount;
			if( time > 5000) return true;
			if( time > 2100) text_Count.visible = true;
			
			if( time > 2500){
				mc_ReadyBar.scaleX = 1.0;
			}else if( time > 2000){
				mc_ReadyBar.scaleX = (time - 2000) / 500;
			}else{
				mc_ReadyBar.scaleX = 0.0;
			}
			return false;
		}
	}
}