//Leg
package PartsSkins{
	import flash.display.Sprite;
	
	public class PartsSkin_04 extends BasePartsSkin{
		
		public function PartsSkin_04(){
			mc_Parts = new Parts_04();
			this.addChild( mc_Parts );
			mc_Parts.Parts_AR.x -= 1.5;
			mc_Parts.Parts_AR.y += 0.2;
			mc_Parts.Parts_AL.x += 1.5;
			mc_Parts.Parts_AL.y -= 0.2;
			
			SetSize( 0 , 18 , 18 );
			
			InitWep( 0 );
			
			InitJoint( 1 );
			SetJointDef( 0 , -7 , 0 );
			SetJoint();
		}
		
		//ポーズの設定
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			
			SetDrec( aim_drec/5 , Drec_LR );
			
			var op:int = 22;
			//速度による位置の設定
			if( speed_x < -15 ){
				mc_Parts.Parts_AR.rotation = op - 30;
				mc_Parts.Parts_AL.rotation = -op - 30;
			}else if( speed_x < 0 ){
				mc_Parts.Parts_AR.rotation = op + speed_x * 2;
				mc_Parts.Parts_AL.rotation = -op + speed_x * 2;
			}else if( speed_x < 15 ){
				mc_Parts.Parts_AR.rotation = op + speed_x;
				mc_Parts.Parts_AL.rotation = -op + speed_x * 2;
			}else{
				mc_Parts.Parts_AR.rotation = op + 15;
				mc_Parts.Parts_AL.rotation = -op + 30;
			}
			
			mc_Parts.Parts_AR.Parts_B.rotation = 10;
			mc_Parts.Parts_AL.Parts_B.rotation = 10;
		}
		
		//待機動作
		override public function Action_Wait( time:int , maxtime:int ):Boolean{
			var drecR1:Number,drecL1:Number,drecR2:Number,drecL2:Number;
			if( time < maxtime/2 ){
				drecR1 = 20 - 20 * time/(maxtime/2);
				drecL1 = -5 - 20 * time/(maxtime/2);
				drecR2 = 20 - 20 * time/(maxtime/2);
				drecL2 = 20 - 20 * time/(maxtime/2);
			}else{
				drecR1 = 0 + 20 * (time/(maxtime/2)-1);
				drecL1 = -25 + 20 * (time/(maxtime/2)-1);
				drecR2 = 0 + 20 * (time/(maxtime/2)-1);
				drecL2 = 0 + 20 * (time/(maxtime/2)-1);
			}
			SetDrec( 0 , Drec_LR );
			
			mc_Parts.Parts_AR.rotation = drecR1;
			mc_Parts.Parts_AL.rotation = drecL1;
			mc_Parts.Parts_AR.Parts_B.rotation = drecR2;
			mc_Parts.Parts_AL.Parts_B.rotation = drecL2;
			return true;
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			SetTriCol( mc_Parts.Parts_AR , num , 1 , r,g,b );
			SetTriCol( mc_Parts.Parts_AR.Parts_B , num , 1 , r,g,b );
			SetTriCol( mc_Parts.Parts_AL , num , -1 , r,g,b );
			SetTriCol( mc_Parts.Parts_AL.Parts_B , num , -1 , r,g,b );
			
		}
	}
}