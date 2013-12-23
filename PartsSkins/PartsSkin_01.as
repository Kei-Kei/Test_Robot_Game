//E_Body
package PartsSkins{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class PartsSkin_01 extends BasePartsSkin{
		
		public function PartsSkin_01(){
			mc_Parts = new Parts_01();
			this.addChild( mc_Parts );
			
			SetSize( 0 , 0 , 6 );
			
			InitWep( 1 );
			SetWepDef( 0 , 8 , 0 , 0 , 0 );
			SetWepDrec( 0 , 0 );
			
			InitJoint( 0 );
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			WepUse[0] = true;
			
			//使用中の武器の方向を変更
			if( WepUse[0] ){
				mc_Parts.Wep_00.rotation = gun_drec - Drec;
				SetWepDrec( 0 , gun_drec );
			}
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			SetTriCol( mc_Parts , num , 1 , r,g,b );
			SetTriCol( mc_Parts.Wep_00 , num , 1 , r,g,b );
		}
	}
}