package{
	import flash.display.Sprite;
	import Muzzles.*;
	
	public class MuzzleUnit extends Sprite{
		public var mc_Muzzle:Sprite;
		public var WepNum:int;
		
		public function MuzzleUnit( num:int , wepnum:int , gap_x:Number , gap_y:Number , drec:int ){
			switch( num ){
				case 1:	mc_Muzzle = new Muzzle_01();	break;
			}
			this.addChild( mc_Muzzle );
			mc_Muzzle.x = gap_x;
			mc_Muzzle.y = gap_y;
			mc_Muzzle.rotation = drec;
			mc_Muzzle.visible = false;
			
			WepNum = wepnum;
		}
		
		public function Play(){
			mc_Muzzle.Play();
		}
		
		public function Reset(){
			mc_Muzzle.visible = true;
			mc_Muzzle.Reset();
		}
		
		public function Stop(){
			mc_Muzzle.visible = false;
			mc_Muzzle.Stop();
		}
	}
}