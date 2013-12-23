//E_Back_Wep
package PartsSkins{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class PartsSkin_03 extends BasePartsSkin{
		
		public function PartsSkin_03(){
			mc_Parts = new Parts_03();
			this.addChild( mc_Parts );
			
			SetSize( 0 , 0 , 7 );
			
			InitWep( 1 );
			
			InitJoint( 0 );
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			WepUse[0] = true;
			
			//使用中の武器の方向を変更
			if( WepUse[0] ){
				SetDrec( gun_drec , Drec_LR );
			}
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			SetTriCol( mc_Parts , num , level , r,g,b );
		}
	}
}