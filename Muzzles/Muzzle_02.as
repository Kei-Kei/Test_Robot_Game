package Muzzles{
	import flash.display.*;
	
	public class Muzzle_02 extends Sprite{
		public var mc_Core:MovieClip;
		
		public var Time:int;
		public var MaxTime:int = 1;
		
		public function Muzzle_02(){
			mc_Core = new Muzzle_Core_01;
			this.addChild( mc_Core );
			Time = 0;
		}
		
		public function Play(){
			if( Time < MaxTime )	mc_Core.visible = true;
			else					mc_Core.visible = false;
			
			Time++;
		}
		
		public function Reset(){
			Time = 0;
		}
		
		public function Stop(){
			Time = MaxTime;
		}
	}
}