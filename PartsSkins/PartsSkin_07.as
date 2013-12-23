//Arm
package PartsSkins{
	import flash.display.Sprite;
	
	public class PartsSkin_07 extends BasePartsSkin{
		
		public function PartsSkin_07(){
			
			mc_Parts = new Parts_07();
			this.addChild( mc_Parts );
			
			SetSize( 0 , 6 , 8 );
			
			InitWep( 0 );
			
			InitJoint( 1 );
			SetJointDef( 0 , 1 , 13 );
			SetJoint();
			
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			
			//照準をつける処理
			if( Mode == 1 ){
				SetDrec( gun_drec / 5 , Drec_LR );
				mc_Parts.Parts_A.Parts_B.rotation = gun_drec - 90 - mc_Parts.rotation * Drec_LR;
				
				//方向をひじから先の部分の方向に修正する
				Drec = gun_drec - 90;
			}else{
				SetDrec( 5 , Drec_LR );
				mc_Parts.Parts_A.Parts_B.rotation = -10;
			}
			
		}
		
		//斬り動作
		override public function Action_Slush( time:int , maxtime:int ):Boolean{
			//武器を動作しているときのみ格闘動作
			if( Mode == 2 ){
				var drec1:Number,drec2:Number;
				drec1 = -75 + 60 * time/maxtime;
				drec2 = -80 + 80 * time/maxtime;
				SetDrec( drec1 , Drec_LR );
				mc_Parts.Parts_A.Parts_B.rotation = drec2;
				
				Drec = drec1 + drec2;
				return true;
			}
			return false;
		}
		//待機動作
		override public function Action_Wait( time:int , maxtime:int ):Boolean{
			var drec1:Number,drec2:Number;
			if( time < maxtime/2 ){
				drec1 = 20 - 30 * time/(maxtime/2);
				drec2 = -10 - 10 * time/(maxtime/2);
			}else{
				drec1 = -10 + 30 * (time/(maxtime/2)-1);
				drec2 = -20 + 10 * (time/(maxtime/2)-1);
			}
			SetDrec( drec1 , Drec_LR );
			mc_Parts.Parts_A.Parts_B.rotation = drec2;
			
			Drec = drec1 + drec2;
			return true;
		}
		
		
		//手のジョイントの設定
		override public function SetJoint(){
			var rad = Drec * Math.PI / 180;
			
			//上腕関節部分の位置のずれを計算
			var drec_0:int,drec_a:int;
			drec_0 = mc_Parts.rotation * Drec_LR;
			drec_a = drec_0 + mc_Parts.Parts_A.rotation;
			
			var gap_x,gap_y:Number;
			gap_x = Utils.RotPosX( mc_Parts.Parts_A.x , mc_Parts.Parts_A.y , drec_0 );
			gap_y = Utils.RotPosY( mc_Parts.Parts_A.x , mc_Parts.Parts_A.y , drec_0 );
			gap_x += Utils.RotPosX( mc_Parts.Parts_A.Parts_B.x , mc_Parts.Parts_A.Parts_B.y , drec_a );
			gap_y += Utils.RotPosY( mc_Parts.Parts_A.Parts_B.x , mc_Parts.Parts_A.Parts_B.y , drec_a );
			
			//先端の座標を計算
			var i:int;
			for( i=0 ; i<JointNum ; i++ ){
				Joint_X[i] = (JointDef_Length[i] * Scale * Math.cos( JointDef_Rad[i] + rad ) + gap_x ) * Drec_LR + Pos_X;
				Joint_Y[i] = JointDef_Length[i] * Scale * Math.sin( JointDef_Rad[i] + rad ) + gap_y + Pos_Y;
			}
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			SetTriCol( mc_Parts.Parts_A , num , 0 , r,g,b );
			SetTriCol( mc_Parts.Parts_A.Parts_B , num , 0 , r,g,b );
		}
	}
}