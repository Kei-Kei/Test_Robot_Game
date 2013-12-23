//Head
package PartsSkins{
	import flash.display.Sprite;
	
	public class PartsSkin_08 extends BasePartsSkin{
		
		public function PartsSkin_08(){
			
			mc_Parts = new Parts_08();
			this.addChild( mc_Parts );
			
			SetSize( 0 , -3 , 3 );
			
			InitWep( 0 );
			
			InitJoint( 0 );
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			SetDrec( aim_drec/2 + 5 , Drec_LR );
		}
		
		//待機動作
		override public function Action_Wait( time:int , maxtime:int ):Boolean{
			SetDrec( 5 , Drec_LR );
			return true;
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			
		}
	}
}