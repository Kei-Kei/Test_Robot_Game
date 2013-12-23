package BattleSet{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Field_Object extends Sprite{
		//位置関係パラメーター
		public var Rad:int = 0;			//大きさ
		public var Pos_X:Number;		//位置
		public var Pos_Y:Number;
		public var Speed_X:Number;		//速度
		public var Speed_Y:Number;
		public var Thrust:Number;		//推力
		public var ThrustDrec_X:Number;
		public var ThrustDrec_Y:Number;
		public var Breaking:Number;		//制動力
		public var AirRegist:Number;	//空気抵抗
		
		public var WallSlide:Boolean;	//壁に沿って動くかどうか
		public var WallReflect:Boolean;	//壁で反射するかどうか
		public var Speed:Number;
		public var Speed_Drec:Number;
		
		//使用状態を表すフラグ（0：未使用、1：味方、2：敵）
		public var Mode:int;
		//このオブジェクトが有効かどうか
		public var Alive:Boolean;
		
		//初期化
		public function Field_Object(){
			Thrust_Drec = new Point();
			Mode = 0;
			Speed = 0.0;
		}
		
		//スピードの計算
		public function CalcSpeed(){
			//制動力計算
			if( Breaking != 1.0 ){
				var u:Number,v:Number;
				var t_drec = Math.atan2( ThrustDrec_Y , ThrustDrec_X );
				var cos_d:Number = Math.cos( t_drec );
				var sin_d:Number = Math.sin( t_drec );
				u = Speed_X * cos_d + Speed_Y * sin_d;
				if( u < 0 )
					u *= Breaking; 
				v = -Speed_X * sin_d + Speed_Y * cos_d;
				v *= Breaking;
				Speed_X = u * cos_d - v * sin_d;
				Speed_Y = u * sin_d + v * cos_d;
			}
			
			//推力を加算
			Speed_X += Thrust * ThrustDrec_X;
			Speed_Y += Thrust * ThrustDrec_Y;
			
			//重力加速度
			//Speed_Y += 1.3;
			
			//極座標計算、減速処理
			Speed_Drec = Math.atan2( Speed_Y , Speed_X );
			Speed = Math.sqrt( Speed_X * Speed_X + Speed_Y * Speed_Y );
			Speed *= AirRegist;
			
			Speed_X = Speed * Math.cos( Speed_Drec );
			Speed_Y = Speed * Math.sin( Speed_Drec );
			if( Math.abs(Speed_X) < 0.2) Speed_X = 0.0;
			if( Math.abs(Speed_Y) < 0.2) Speed_Y = 0.0;
			
		}
		
		//移動処理
		public function Move(){
			//移動処理
			Pos_X += Speed_X;
			Pos_Y += Speed_Y;
		}

		//値のセット------------------------------------------------------------------------------------------
		public function SetThrustDrec( t_d_x:Number , t_d_y:Number ){
			ThrustDrec_X = t_d_x;
			ThrustDrec_Y = t_d_y;
		}
	}
}