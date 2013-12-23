package PartsSkins{
	import flash.display.*;
	
	import BattleSet.MuzzleUnit;
	
	public class PartsSkin_013 extends BasePartsSkin{
		
		public function PartsSkin_013(){
			
			mc_Parts = new Parts_013();
			this.addChild( mc_Parts );
			
			SetSize( 0 , 0 , 18 );
			
			InitWep( 0 );
			
			InitJoint( 1 );
			SetJointDef( 0 , -4 , -10 );
			SetJoint();

		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			
			if( gun_drec > 15 ){
				SetDrec( 15 , Drec_LR );
			}else if( gun_drec < -15 ){
				SetDrec( -15 , Drec_LR );
			}else{
				SetDrec( gun_drec , Drec_LR );
			}
			
			if( speed_x < -15 ){
				mc_Parts.Parts_A.rotation = -30 + 180;
			}else if( speed_x < 15 ){
				mc_Parts.Parts_A.rotation = 2 * speed_x + 180;
			}else{
				mc_Parts.Parts_A.rotation = 30 + 180;
			}
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			
		}
	}
}