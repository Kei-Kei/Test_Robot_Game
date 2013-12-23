package BattleSet{
	public class Target_Unit{
		
		private var B_Sys:Battle_System;
		
		//ターゲットとの距離、角度
		public var Dist:int;
		public var Drec:int;
		//照準に入ってからの時間
		public var Time:int;
		
		//照準に入っているかどうか
		public var InSight:Boolean;
		//ロックオンされているかどうか
		public var Rocked:Boolean;
		
/*		//使用状態
		public var Use:Boolean;*/
		
		public function Target_Unit(){
			Reset();
		}
		
		//リセット
		public function Reset(){
			InSight = false;
			Rocked = false
			Time = -1;
		}
		
		//他機体の参照をもらってくる
		public function Link_Other( bos:Battle_System ){
			B_Sys = bos;
		}
		
/*		//ターゲットの基本的なパラメーターを代入
		public function SetTarget( pos_x:Number , pos_y:Number , speed_x:Number , speed_y:Number , m_use:Boolean){
			Use = m_use;
		}*/
		
		//ターゲットと自機の間の距離を測定する
		public function CalcDist( my_x:Number , my_y:Number , range:int ):Boolean{
			var dist_x:int = B_Sys.Pos_X - my_x;
			var dist_y:int = B_Sys.Pos_Y - my_y;
			Dist = Math.sqrt( dist_x*dist_x + dist_y*dist_y );
			//ロックオン範囲内に入っているか計算
			if( Dist <= range )	return true;
			else				return false;
		}
		
		//ターゲットと自機の間の角度を測定する
		public function CalcDrec( my_x:Number , my_y:Number , reticle_drec:int , range:int , drec_LR:int ):Boolean{
			Drec = Math.atan2( B_Sys.Pos_Y - my_y , B_Sys.Pos_X - my_x )*180/Math.PI;
			//ロックオン角度内に入っているか計算
			var drec:int = Utils.AdjustDrec( Drec , drec_LR );
			var r_drec:int = Utils.AdjustDrec( reticle_drec , drec_LR );
			if( drec > r_drec + range )		return false;
			else if( drec < r_drec - range )	return false;
			else return true;
		}
		
		//ターゲットと武器の間の角度を測定する
		public function CalcGunDrec( gun_x:Number , gun_y:Number ):Number{
			return Math.atan2( B_Sys.Pos_Y - gun_y , B_Sys.Pos_X - gun_x )*180/Math.PI;
		}
		
		//偏差射撃の角度を算出
		public function CalcFSS( my_x:Number , my_y:Number , my_sx:Number , my_sy:Number ){
			
		}
		
		//状態を返す
		public function retX(){
			if( B_Sys.Pos_X != null )	return B_Sys.Pos_X;
			else return 0;
		}
		public function retY(){
			if( B_Sys.Pos_Y != null )	return B_Sys.Pos_Y;
			else return 0;
		}
		public function retMode(){
			return B_Sys.Mode;
		}
		public function retAlive(){
			return B_Sys.Alive;
		}

	}
}