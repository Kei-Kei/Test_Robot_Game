package PartsSkins{
	import flash.display.*;
	
	import BattleSet.MuzzleUnit;
	
	public class PartsSkin_011 extends BasePartsSkin{
		
		public function PartsSkin_011(){
			
			mc_Parts = new Parts_011();
			this.addChild( mc_Parts );
			
			SetSize( 0 , 0 , 0 );
			
			InitWep( 2 );
			
			InitJoint( 0 );
			
			//照準は親パーツに任せる
			AimType = 2;
		}
		
		override public function SetPose( thrust:Number , thrust_drec:int , boost:Boolean , speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){

		}
		//斬り動作
		override public function Action_Slush( time:int , maxtime:int ):Boolean{
			//武器を動作しているときのみ格闘動作
			if( WepUse[0] ){
				SetDrec( Drec + 30 * time/maxtime + 30 , Drec_LR );
				return true;
			}
			return false;
		}
		
		//パーツの色を決定
		public function SetColor( num:int , level:int , r:int , g:int , b:int ){
			
			SetTriCol( mc_Parts , num , 0 , r,g,b );
			
		}
	}
}