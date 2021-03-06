﻿package PartsSkins{
	import flash.display.*;
	
	import BattleSet.MuzzleUnit;
	
	public class PartsSkin_015 extends BasePartsSkin{
		
		public function PartsSkin_015(){
			
			mc_Parts = new Parts_015();
			this.addChild( mc_Parts );
			
			SetSize( 0 , 0 , 10 );
			
			InitWep( 1 );
			SetWepDef( 0 , 36 , -3 , 0 , 0 );
			SetWepDrec( 0 , 0 );
			
			InitJoint( 0 );
			
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			if( WepUse[0] ){
				SetDrec( gun_drec , Drec_LR );
				SetWepDrec( 0 , Drec );
			}else{
				SetDrec( -90 , Drec_LR );
				SetWepDrec( 0 , Drec );
			}
		}
		
		//銃口のエフェクトを追加
		override public function SetMuzzle( num:int , wepnum:int , gap_x:Number , gap_y:Number , drec:int ){
			Muzzle[Muzzle.length] = new MuzzleUnit( num , wepnum , gap_x , gap_y , drec );
			mc_Parts.addChild( Muzzle[Muzzle.length-1] );
			Muzzle[Muzzle.length-1].x = 36;
			Muzzle[Muzzle.length-1].y = -3;
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			
		}
	}
}