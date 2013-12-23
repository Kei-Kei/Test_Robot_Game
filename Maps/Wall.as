package Maps{
	import MiniObj.WallHit;
	import BattleSet.*;
	
	public class Wall{
		public var S_X:int;	//始点座標
		public var S_Y:int;
		public var G_X:int;	//終点座標
		public var G_Y:int;
		public var N_X:Number;	//法線ベクトル
		public var N_Y:Number;
		public var D:Number;
		public var Drec:Number;	//直線の傾き（始点を原点とする
		
		public var E_Xmax;	//当たり判定の簡易判定用範囲
		public var E_Xmin;
		public var E_Ymax;
		public var E_Ymin;
		
		public function Wall(){
		}
		
		//当たり判定に必要な変数のいくつかを前計算しておく
		public function Calc(){
			//ベクトルを求める
			var sgx:int = G_X - S_X;
			var sgy:int = G_Y - S_Y;
			//法線ベクトルを求める
			N_X = -sgy;
			N_Y = sgx;
			var n_length:Number;
			n_length = Math.sqrt( N_X * N_X + N_Y * N_Y );
			n_length = 1 / n_length;
			N_X *= n_length;
			N_Y *= n_length;
			//謎の変数？Dを求める
			D = -(S_X * N_X + S_Y * N_Y);
			
			//直線の傾きを求める
			Drec = Math.atan2( sgy , sgx );
			
			//当たり判定の簡易判定用計算
			if( S_X >= G_X ){
				E_Xmax = S_X + 100;
				E_Xmin = G_X - 100;
			}else{
				E_Xmax = G_X + 100;
				E_Xmin = S_X - 100;
			}
			if( S_Y >= G_Y ){
				E_Ymax = S_Y + 100;
				E_Ymin = G_Y - 100;
			}else{
				E_Ymax = G_Y + 100;
				E_Ymin = S_Y - 100;
			}
		}
		
		//移動体との衝突判定
		public function CalcHit( f_obj:Field_Object ):WallHit{
			
			var c_hit:WallHit = new WallHit();
			
			//処理軽減用の簡易判定
			var easy:Boolean;
			if( f_obj.Pos_X > E_Xmax )		easy = true;
			else if( f_obj.Pos_X < E_Xmin )	easy = true;
			else if( f_obj.Pos_Y > E_Ymax )	easy = true;
			else if( f_obj.Pos_Y < E_Ymin )	easy = true;
			if( easy ){
				c_hit.Set( 0 , 0 , false );
				return c_hit;
			}
			
			//ここから本計算
			var s_x:Number = -N_X * f_obj.Rad + f_obj.Speed_X;
			var s_y:Number = -N_Y * f_obj.Rad + f_obj.Speed_Y;
			var t:Number = -( N_X * f_obj.Pos_X + N_Y * f_obj.Pos_Y + D ) / ( N_X * s_x + N_Y * s_y );
			var c_x:Number , c_y:Number;	//交差座標
			var hit:Boolean = false;
			
			//もし壁の直線と交差する場合
			if( t > 0 && t <= 1 ){
				//交差座標の計算
				c_x = f_obj.Pos_X + s_x * t;
				c_y = f_obj.Pos_Y + s_y * t;
				//当たり判定の確認
				if( (c_x - S_X) * (c_x - G_X) + (c_y - S_Y) * (c_y - G_Y) < 0 ){
					hit = true;
				}
			}
			
			//壁に衝突した場合の処理
			if( hit ){
				//壁に沿って動く、あるいは壁に反射するオブジェクトの場合
				if( f_obj.WallSlide || f_obj.WallReflect ){
					//壁の法線方向とオブジェクトの進行方向ベクトルが逆向きの場合（つまり衝突）
					if( N_X * f_obj.Speed_X + N_Y * f_obj.Speed_Y < 0 ){
						//壁に沿って動くオブジェクトの場合
						if( f_obj.WallSlide ){
							//速度を修正
							f_obj.Speed *= Math.cos( f_obj.Speed_Drec - Drec );
							f_obj.Speed_X = f_obj.Speed * Math.cos( Drec );
							f_obj.Speed_Y = f_obj.Speed * Math.sin( Drec );
						//壁に反射するオブジェクトの場合
						}else{
							//壁の法線とオブジェクトのスピードの内積の2倍を求める
							var vec_2no = 2 * ( -f_obj.Speed_X * N_X -f_obj.Speed_Y * N_Y );
							//速度を修正する
							f_obj.Speed_X += vec_2no * N_X;
							f_obj.Speed_Y += vec_2no * N_Y;
						}
					}
				}
				//位置を修正
				f_obj.Pos_X = c_x + N_X * (f_obj.Rad + 1 );
				f_obj.Pos_Y = c_y + N_Y * (f_obj.Rad + 1 );
			}
			
			//交差座標を返す
			if( hit )	c_hit.Set( c_x , c_y , true );
			else		c_hit.Set( 0 , 0 , false );
			return c_hit;
		}
	}
}