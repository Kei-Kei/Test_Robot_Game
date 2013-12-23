//Body
package PartsSkins{
	import flash.display.Sprite;
	
	public class PartsSkin_06 extends BasePartsSkin{
		
		public function PartsSkin_06(){
			
			mc_Parts = new Parts_06();
			this.addChild( mc_Parts );
			
			SetSize( 0 , -7 , 7 );
			
			InitWep( 0 );
			
			InitJoint( 3 );
			SetJointDef( 0 , 0 , -15.5 );		//Head
			SetJointDef( 1 , 0 , -13 );		//Arm
			SetJointDef( 2 , -7 , -13 );	//Back
			SetJoint();
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			
		}
	}
}