//Hand_Gun
package PartsSkins{
	import flash.display.Sprite;
	
	import BattleSet.MuzzleUnit;
	
	public class PartsSkin_09 extends BasePartsSkin{
		
		public function PartsSkin_09(){
			
			mc_Parts = new Parts_09();
			this.addChild( mc_Parts );
			mc_Parts.Grip.visible = false;
			
			SetSize( 0 , 0 , 0 );
			
			InitWep( 1 );
			SetWepDef( 0 , 7 , -2 , 0 , 0 );
			SetWepDrec( 0 , 0 );
			
			InitJoint( 0 );
			
			//照準は親パーツに任せる
			AimType = 1;
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			SetDrec( Drec + 90 , Drec_LR );
			
			SetWepDrec( 0 , Drec );
		}
		
		//銃口のエフェクトを追加
		override public function SetMuzzle( num:int , wepnum:int , gap_x:Number , gap_y:Number , drec:int ){
			Muzzle[Muzzle.length] = new MuzzleUnit( num , wepnum , gap_x , gap_y , drec );
			mc_Parts.addChild( Muzzle[Muzzle.length-1] );
			Muzzle[Muzzle.length-1].x = 7;
			Muzzle[Muzzle.length-1].y = -2;
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			
		}
	}
}