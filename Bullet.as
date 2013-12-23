package{
	import flash.display.Sprite;
	import BattleSet.*;
	
	public class Bullet extends Field_Object{
		
		//弾丸画像
		public var mc_Bullet:Sprite;
		public var mc_Bullet_Slave:Array = new Array();
		
		//定数
		private var root2:Number = Math.sqrt(2);
		private var radeg:Number = 180/Math.PI;
		
		//弾丸変数
		private var Slave_Pos_X:Array = new Array();	//過去の位置情報
		private var Slave_Pos_Y:Array = new Array();	//過去の位置情報
		private var Time:int;		//経過時間
		private var Hit:Boolean;	//弾が命中したか
		
		//ターゲットの座標
		public var Target:int;
		
		//弾丸の性質
		private var Bullet_param:Data_Bullet = new Data_Bullet(); 
		
		//コンストラクタ
		public function Bullet(){
			Alive = false;
		}
		
		//弾丸の削除(戦闘終了時)-----------------------------------------------------------------------------------------
		public function Close(){
			if( Mode != 0 ){
				Mode = 0;
				if( this.numChildren > Bullet_param.Bullet_Slave_Num ){
					this.removeChild(mc_Bullet);
				}
				var i:int;
				for(i=Bullet_param.Bullet_Slave_Num - this.numChildren ; i<Bullet_param.Bullet_Slave_Num ; i++){
					this.removeChild(mc_Bullet_Slave[i]);
				}
			}
		}
		
		//弾丸の生成------------------------------------------------------------------------------------------
		//弾丸使用の判定
		public function shotBullet( mode:int , shot:Object , speed_x:Number , speed_y:Number , bullet:Data_Bullet){
			if( Mode == 0 ){
				Mode = mode;
				//弾丸の生成
				createBullet( shot.Pos_X , shot.Pos_Y , shot.T_Drec , shot.Drec ,
							  speed_x , speed_y , shot.Speed ,
							  shot.Target , bullet );
				Alive = true;
				return true;
			}else{
				return false;
			}
		}
		//弾の生成
		public function createBullet( start_x:int , start_y:int , t_drec:int , drec:int , 
									  speed_x:Number , speed_y:Number , speed:int , 
									  target:int , bullet:Data_Bullet){
			//弾丸データのコピー
			Bullet_param = bullet;
			//壁滑り、反射の設定
			WallSlide = Bullet_param.WallSlide;
			WallReflect = Bullet_param.WallReflect;
			
			//親弾丸の表示
			switch( Bullet_param.Bullet_Graphic ){
				case 1:	mc_Bullet = new Bullet01();	break;
				case 2:	mc_Bullet = new Bullet02();	break;
				case 3:	mc_Bullet = new Bullet03();	break;
				case 4:	mc_Bullet = new Bullet04();	break;
				case 5:	mc_Bullet = new Bullet05();	break;
			}
			this.addChild(mc_Bullet);
			mc_Bullet.x = 0;
			mc_Bullet.y = 0;
			mc_Bullet.rotation = t_drec;
			mc_Bullet.visible = false;
			mc_Bullet.scaleY = 1.0;
			
			var i:int;
			
			//子弾丸の表示
			for(i=0 ; i<Bullet_param.Bullet_Slave_Num ; i++){
				//子mc生成
				switch( Bullet_param.Bullet_Graphic ){
					case 1:	mc_Bullet_Slave[i] = new Bullet01_slave();	break;
					case 2:	mc_Bullet_Slave[i] = new Bullet02_slave();	break;
					case 3:	mc_Bullet_Slave[i] = new Bullet03_slave();	break;
					case 4:	mc_Bullet_Slave[i] = new Bullet04_slave();	break;
					case 5:	mc_Bullet_Slave[i] = new Bullet05_slave();	break;
				}
				this.addChild(mc_Bullet_Slave[i]);
				mc_Bullet_Slave[i].x = 0;
				mc_Bullet_Slave[i].y = 0;
				mc_Bullet_Slave[i].rotation = drec;
				mc_Bullet_Slave[i].scaleX = 0.0;
				mc_Bullet_Slave[i].scaleY = 1.0 + 0.05*i;
			}
			if( Bullet_param.Bullet_Slave_Num > 0){
				this.setChildIndex( mc_Bullet , this.getChildIndex( mc_Bullet_Slave[Bullet_param.Bullet_Slave_Num-1] ) );
			}
			
			//位置初期化
			Pos_X = start_x;
			Pos_Y = start_y;
			//速度初期化
			ThrustDrec_X = Math.cos( t_drec * Math.PI / 180 );
			ThrustDrec_Y = Math.sin( t_drec * Math.PI / 180 );
			//機体速度に応じた初速の付加
			Speed_X = speed_x;
			Speed_Y = speed_y;
			Speed_X += speed * Math.cos( drec * Math.PI/180 );
			Speed_Y += speed * Math.sin( drec * Math.PI/180 );
			AirRegist = Bullet_param.AirRegist;
			Breaking = Bullet_param.Breaking;
			//時間の初期化
			Time = 0;
			Hit = false;
			Life = true;
			
			//過去位置情報初期化
			for(i=0 ; i<Bullet_param.Bullet_Slave_Num + 1 ; i++){
				Slave_Pos_X[i] = new Number();
				Slave_Pos_Y[i] = new Number();
				Slave_Pos_X[i] = Pos_X;
				Slave_Pos_Y[i] = Pos_Y;
			}
			
			//ターゲットの番号の入力
			Target = target;
			
		}
		
		//弾丸の移動------------------------------------------------------------------------------------------
		public function moveBullet( tar_x , tar_y ){
			
			//弾丸の誘導
			if( Bullet_param.Horming_Flag && Target != -1 ){
				if( Time >= Bullet_param.Horming_Start && Time <= Bullet_param.Horming_End ){
					var t_drec:Number = Math.atan2( ThrustDrec_Y , ThrustDrec_X );
					var t2p_gap:Number;
					t2p_gap = Math.atan2( tar_y - Pos_Y , tar_x - Pos_X ) - t_drec;
					t2p_gap = Utils.fixDrec2( t2p_gap );
					
					if( Math.abs(t2p_gap) > Bullet_param.Horming_Power ){
						if( t2p_gap > 0 )	t_drec += Bullet_param.Horming_Power;
						else				t_drec -= Bullet_param.Horming_Power;
					}else{
						t_drec += t2p_gap;
					}
					SetThrustDrec( Math.cos( t_drec ) , Math.sin( t_drec ) );
				}
			}
			
			//推力の決定
			Thrust = 0;
			if( Time >= Bullet_param.Thrust_Start ){
				if( Time <= Bullet_param.Thrust_End || Bullet_param.Thrust_End == -1 ){
					Thrust = Bullet_param.Thrust;
				}
			}
			
			//移動
			CalcSpeed();
		}
		
		//表示
		public function Disp( gap_x:int , gap_y:int ):int{
			//弾丸の表示
			mc_Bullet.x = Pos_X + gap_x;
			mc_Bullet.y = Pos_Y + gap_y;
			if( Bullet_param.Horming_Flag ){
				mc_Bullet.rotation = Math.atan2( ThrustDrec_Y , ThrustDrec_X ) * 180 / Math.PI;
			}
			mc_Bullet.visible = true;
			
			var i:int;
			
			//過去位置の格納
			for(i=Bullet_param.Bullet_Slave_Num ; i>0 ; i--){
				Slave_Pos_X[i] = Slave_Pos_X[i-1];
				Slave_Pos_Y[i] = Slave_Pos_Y[i-1];
			}
			Slave_Pos_X[0] = Pos_X;
			Slave_Pos_Y[0] = Pos_Y;
			
			var distX:Number,distY:Number;
			
			//子弾丸の移動
			for(i=0 ; i<Bullet_param.Bullet_Slave_Num ; i++){
				mc_Bullet_Slave[i].x = Slave_Pos_X[i] + gap_x;
				mc_Bullet_Slave[i].y = Slave_Pos_Y[i] + gap_y;
				distX = Slave_Pos_X[i] - Slave_Pos_X[i+1];
				distY = Slave_Pos_Y[i] - Slave_Pos_Y[i+1];
				mc_Bullet_Slave[i].scaleX = Math.sqrt( distX*distX + distY*distY ) / 10.0;
				mc_Bullet_Slave[i].rotation = Math.atan2( distY , distX ) * radeg;
				mc_Bullet_Slave[i].alpha = (Bullet_param.Bullet_Slave_Num - i)/Bullet_param.Bullet_Slave_Num;
			}
			
			return KillBullet();
		}
		
		//弾丸命中時の処理---------------------------------------------------------------------------------------
		public function HitBullet( wallhit:Boolean ):Boolean{
			if( Time < Bullet_param.Bullet_Life ){
				//弾丸が壁に衝突した場合
				if( wallhit ){
					//弾丸が壁に沿って動かずさらに反射もしない場合
					if( !WallSlide && !WallReflect ){
						Time = Bullet_param.Bullet_Life;
						Alive = false;
					}
				//弾丸が非貫通性の場合
				}else if( !Bullet_param.Penet_Flag ){
					Time = Bullet_param.Bullet_Life;
					Alive = false;
				}
				Hit = true;
				return true;
			}
			return false;
		}
		
		//弾丸の後始末-----------------------------------------------------------------------------------------
		private function KillBullet():int{
			var ret:int = 1;
			//弾丸が爆発したかを判断する。
			if( Hit ){
				ret = 3;
				Hit = false;
			}else if( Time == Bullet_param.Bullet_Life ){
				ret = 2;
			}
			
			//寿命がきた弾丸を削除する
			if( Time >= Bullet_param.Bullet_Life ){
				//弾丸の寿命が尽きた瞬間（射程限界、命中時
				if( Time == Bullet_param.Bullet_Life ){
					this.removeChild(mc_Bullet);
					//子弾丸を持っていない場合は弾丸消去メッセージを送る
					if( Bullet_param.Bullet_Slave_Num == 0 )	ret *= -1;
				}else if( Time - Bullet_param.Bullet_Life == Bullet_param.Bullet_Slave_Num + 1 ){
					//すべての子弾丸が消えたら弾丸消去のメッセージを返す
					ret *= -1;
				}else if( Time - Bullet_param.Bullet_Life >= 1 ){
					//子弾丸をひとつづつ消していく
					this.removeChild(mc_Bullet_Slave[Time - Bullet_param.Bullet_Life - 1]);
				}
			}else{
				ret = 0;
			}
			
			Time++;
			if( ret < 0 )	Mode = 0;
			return ret;
		}
		
		//弾丸のパラメーターを返す関数郡-----------------------------------------------------------------------------------------
		public function retDamage(){
			return Bullet_param.Power;
		}
		public function ExHit(){
			return Bullet_param.Explode_Hit;
		}
		public function ExHitSize(){
			return Bullet_param.Explode_Hit_Size;
		}
		public function ExErase(){
			return Bullet_param.Explode_Erase;
		}
		public function ExEraseSize(){
			return Bullet_param.Explode_Erase_Size;
		}
	}
}