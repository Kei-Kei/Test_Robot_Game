package PartsSkins{
	import flash.display.*;
	
	import BattleSet.MuzzleUnit;
	
	public class PartsSkin_014 extends BasePartsSkin{
		
		public function PartsSkin_014(){
			
			mc_Parts = new Parts_014();
			this.addChild( mc_Parts );
			
			SetSize( -4 , -2 , 5 );
			
			InitWep( 1 );
			SetWepDef( 0 , -4 , -5 , 0 , 0 );
			SetWepDrec( 0 , 0 );
			
			InitJoint( 0 );
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			if( WepUse[0] ){
				mc_Parts.gotoAndStop(2);
				SetDrec( gun_drec + 90 , Drec_LR );
				SetWepDrec( 0 , Drec );
			}else{
				mc_Parts.gotoAndStop(1);
				SetDrec( 20 , Drec_LR );
				SetWepDrec( 0 , Drec );
			}
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			SetTriCol( mc_Parts , num , 0 , r,g,b );
		}
	}
}