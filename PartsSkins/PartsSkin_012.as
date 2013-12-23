package PartsSkins{
	import flash.display.*;
	
	import BattleSet.MuzzleUnit;
	
	public class PartsSkin_012 extends BasePartsSkin{
		
		public function PartsSkin_012(){
			
			mc_Parts = new Parts_012();
			this.addChild( mc_Parts );
			
			SetSize( 0 , 0 , 27 );
			
			InitWep( 1 );
			SetWepDef( 0 , 22 , 0 , 0 , 0 );
			SetWepDrec( 0 , 0 );
			
			InitJoint( 0 );

		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			WepUse[0] = true;
			
			//使用中の武器の方向を変更
			if( WepUse[0] ){
				//mc_Parts.rotation = gun_drec - Drec;
				SetWepDrec( 0 , gun_drec );
				SetDrec( gun_drec , Drec_LR );
			}
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			
		}
	}
}