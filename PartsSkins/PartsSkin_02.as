//E_Body
package PartsSkins{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class PartsSkin_02 extends BasePartsSkin{
		
		public function PartsSkin_02(){
			mc_Parts = new Parts_02();
			this.addChild( mc_Parts );
			
			SetSize( -2 , 2 , 15 );
			
			InitWep( 0 );
			
			InitJoint( 1 );
			SetJointDef( 0 , -6 , -9 );
			SetJoint();
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			SetDrec( aim_drec/5 , Drec_LR );
			
			if( thrust_drec - Drec < 45 && thrust_drec - Drec > -45 ){
				mc_Parts.Boost.rotation = thrust_drec - Drec + 180;
				mc_Parts.Boost.Fire.scaleX = thrust*2;
			}else{
				mc_Parts.Boost.Fire.scaleX = 1.0;
			}
			
			if( speed_x < -15 ){
				mc_Parts.Tail.rotation = -30 + 180;
			}else if( speed_x < 15 ){
				mc_Parts.Tail.rotation = 2 * speed_x + 180;
			}else{
				mc_Parts.Tail.rotation = 30 + 180;
			}
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			/*var rN,gN,bN,rL,gL,bL,rS,gS,bS:int;
			rN = RetCol( level , 1 , r );
			gN = RetCol( level , 1 , g );
			bN = RetCol( level , 1 , b );
			rL = RetCol( level , 2 , r );
			gL = RetCol( level , 2 , g );
			bL = RetCol( level , 2 , b );
			rS = RetCol( level , 0 , r );
			gS = RetCol( level , 0 , g );
			bS = RetCol( level , 0 , b );
			
			switch( num ){
			case 1:
				mc_Parts.Col_1.N.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rN, gN, bN, 0);
				mc_Parts.Col_1.L.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rL, gL, bL, 0);
				mc_Parts.Col_1.S.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rS, gS, bS, 0);
				mc_Parts.Tail.Col_1.N.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rN, gN, bN, 0);
				mc_Parts.Tail.Col_1.L.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rL, gL, bL, 0);
				mc_Parts.Tail.Col_1.S.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rS, gS, bS, 0);
				break;
			case 2:
				mc_Parts.Col_2.N.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rN, gN, bN, 0);
				mc_Parts.Col_2.L.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rL, gL, bL, 0);
				mc_Parts.Col_2.S.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rS, gS, bS, 0);
				mc_Parts.Tail.Col_2.N.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rN, gN, bN, 0);
				mc_Parts.Tail.Col_2.L.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rL, gL, bL, 0);
				mc_Parts.Tail.Col_2.S.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rS, gS, bS, 0);
				break;
			case 3:
				mc_Parts.Tail.Col_3.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rN, gN, bN, 0);
				break;
			}*/
		}
	}
}