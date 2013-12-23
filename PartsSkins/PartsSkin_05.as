//Boost
package PartsSkins{
	import flash.display.Sprite;
	
	public class PartsSkin_05 extends BasePartsSkin{
		
		public function PartsSkin_05(){
			mc_Parts = new Parts_05();
			this.addChild( mc_Parts );
			
			SetSize( -7 , 1 , 7 );
			
			InitWep( 0 );
			
			InitJoint( 0 );
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			
			//進行方向によって前方ブーストと後方ブースとの表示を切り替え
			if( thrust_drec < 90 && thrust_drec >= -90 ){
				mc_Parts.rotation = ( thrust_drec ) * 2/3 * Drec_LR;
				mc_Parts.Fire.scaleX = thrust;
				mc_Parts.BackFire.scaleX = 0.0;
			}else{
				if( thrust_drec - Drec > 0){
					mc_Parts.rotation = ( (thrust_drec - 180 ) * 2/3 ) * Drec_LR;
				}else{
					mc_Parts.rotation = ( (thrust_drec + 180 ) * 2/3 ) * Drec_LR;
				}
				mc_Parts.Fire.scaleX = 0.0;
				mc_Parts.BackFire.scaleX = thrust;
			}
			
			//ブーストをふかしていなかったらエフェクトを消す
			if( !boost ){
				mc_Parts.Fire.scaleX = 0.0;
				mc_Parts.BackFire.scaleX = 0.0;
			}
		}
		
		//待機動作
		override public function Action_Wait( time:int , maxtime:int ):Boolean{
			var drec:Number;
			if( time < maxtime/2 ){
				drec = -25 + 25 * time/(maxtime/2);
			}else{
				drec = 0 - 25 * (time/(maxtime/2)-1);
			}
			SetDrec( drec , Drec_LR );
			
			//ブーストエフェクトを消す
			mc_Parts.Fire.scaleX = 0.0;
			mc_Parts.BackFire.scaleX = 0.0;
			return true;
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , level , r,g,b );
			
		}
	}
}