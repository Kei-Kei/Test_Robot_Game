package BattleSet{
	public class AI_Unit{
		
		//AIの行動
		public var AI:Data_AI = new Data_AI();
		//所属グループの情報
		public var E_Group:Data_Enemy_Group = new Data_Enemy_Group();
		//戦闘モード
		public var B_Mode:int;
		//戦闘中かどうかのフラグ
		public var B_Flag:Boolean;
		
		//自分の状態
		public var Pos_X:Number;
		public var Pos_Y:Number;
		public var Thrust_X:Number;	//推力方向
		public var Thrust_Y:Number;	//
		public var Boost:Boolean;	//ブースト移動するか
		public var Dash:Boolean;	//ダッシュするか
		public var Attack:Boolean;	//攻撃状態か
		public var SelectWeapon:int;//現在選択している武装
		public var C_Wep:Boolean;	//武装を変更するか
		public var AimTarget:int;	//狙っているターゲット
		
		//他の機体の情報
		private var B_Sys:Array;
		//目標機体の状態
		private var Target_X:Number;
		private var Target_Y:Number;
		private var Target_Gun:int;
		
		//状態
		private var E_Dist:Number;	//ターゲットとの距離
		public var S_Count:int;		//ターゲットの視界内に捕らえられたカウント
		public var Pry_Side:int;
		
		//コンストラクタ
		public function AI_Unit(){
		}
		
		//AIの生成
		public function createAI( ai_data:Data_AI , group_data:Data_Enemy_Group , b_sys:Array ){
			AI = ai_data;
			E_Group = group_data;
			B_Mode = 0;
			S_Count = 0;
			Pry_Side = 1;
			Boost = false;
			Dash = false;
			
			AimTarget = -1;
			B_Sys = b_sys;
			
			B_Flag = false;
		}
		
		//自分の状態を更新
		public function SetMyData( pos_x:Number , pos_y:Number , tst_x:Number , tst_y:Number , sw:int ){
			Pos_X			= pos_x;
			Pos_Y			= pos_y;
			Thrust_X		= tst_x;
			Thrust_Y		= tst_y;
			SelectWeapon 	= sw
		}
		
		//推進状態を更新
		private function SetThrust( dash:Boolean , boost:Boolean ){
			Dash = dash;
			Boost = boost;
		}
		
		//ターゲットの状態を更新
		public function SetTargetData( tar_x:Number , tar_y:Number , tar_gun:int ){
			Target_X 	= tar_x;
			Target_Y 	= tar_y;
			Target_Gun	= tar_gun;
		}
		
		//ターゲットの選定に関する処理
		//ターゲットの選定
		public function SelectTarget( my_mode:int ){
			var i:int;
			AimTarget = -1;
			for( i=0 ; i<B_Sys.length ; i++ ){
				//対象が使用中で
				if( B_Sys[i].Mode != 0 ){
					//かつ自分とは違う陣営の機体である場合に。
					if( B_Sys[i].Mode != my_mode ){
						AimTarget = i;
						break;
					}
				}
			}
		}
		
		//移動に関する処理---------------------------------------------------------------------------------------
		//推進方向の決定
		public function DecideThrust( pos_x:Number , pos_y:Number , tst_x:Number , tst_y:Number , sw:int ){
			
			SetMyData( pos_x , pos_y , tst_x , tst_y , sw );
			if( AimTarget != -1 ){
				SetTargetData( B_Sys[AimTarget].Pos_X , B_Sys[AimTarget].Pos_Y , B_Sys[AimTarget].retGun() );
				if( B_Flag ){
					//追跡を続行するか判定
					if( !E_Group.InnerAreaH( Target_X , Target_Y ) ){
						B_Flag = false;
					}
				}else{
					//索敵範囲内にターゲットが潜入したか判定
					if( E_Group.InnerAreaS( Target_X , Target_Y ) ){
						B_Flag = true;
					}
				}
				B_Mode = 0;
			}else{
				B_Flag = false;
			}
			//戦闘モードならば
			if( B_Flag ){
				//推力方向の決定
				switch( AI.B_Type[B_Mode].Battle_Type ){
				case 0:	//NearPlayer
					Trace_Point( Target_X , Target_Y );
					break;
				case 1:	//Fix
					if( Math.random() > 0.10 ){
						Trace_Point( AI.B_Type[B_Mode].Battle_Cen_X + E_Group.Area_Cen_X ,
									 AI.B_Type[B_Mode].Battle_Cen_Y + E_Group.Area_Cen_Y );
					}else{
						RandomWalk();
					}
					//ターゲットとの距離を計算しておく
					var sx:Number = Target_X - Pos_X;
					var sy:Number = Target_Y - Pos_Y;
					E_Dist = Math.sqrt( sx*sx + sy*sy );
					break;
				}
				//回避行動
				if( Math.random() < AI.B_Type[B_Mode].Pary_Per ) Pary( Target_X , Target_Y , Target_Gun );
			}else{
				Trace_Point( E_Group.Area_Cen_X , E_Group.Area_Cen_Y );
			}
		}
		
		//特定ポイントに追従する動き
		private function Trace_Point( tar_x:Number , tar_y:Number){
			
			//目標の位置に応じて推進方向を決定
			var sx:Number = tar_x - Pos_X;
			var sy:Number = tar_y - Pos_Y;
			E_Dist = Math.sqrt( sx*sx + sy*sy );
			var dist2:Number;
			if( E_Dist != 0 )	dist2 = 1/E_Dist;
			else			dist2 = E_Dist;
			Thrust_X = sx*dist2;
			Thrust_Y = sy*dist2;
			//目標と保つべき距離より近かったら目標から遠ざかる
			if( E_Dist - AI.B_Type[B_Mode].Battle_Range < 0 ){
				Thrust_X *= -1;
				Thrust_Y *= -1;
			}
			
			//目標との距離に応じて速度を変更
			var b_mode:Number = Math.random();
			if( E_Dist < AI.B_Type[B_Mode].Battle_Range + AI.B_Type[B_Mode].Battle_Frac ){
				if( b_mode > 0.99 )			SetThrust( true , true );
				else if( b_mode > 0.95 )	SetThrust( false , true );
				else						SetThrust( false , false );
			}else{
				if( b_mode > 0.95 )			SetThrust( true , true );
				else						SetThrust( false , true );
			}
			
		}
		
		//ランダムに移動
		private function RandomWalk(){
			Thrust_X = Math.random()*1.0;
			Thrust_Y = Math.sqrt( 1 - Thrust_X * Thrust_X );
			
			if( Math.random() > 0.5 )	Thrust_X *= -1;
			if( Math.random() > 0.5 )	Thrust_Y *= -1;
			
			var b_mode:Number = Math.random();
			if( b_mode > 0.00 )			SetThrust( true , true );
			else if( b_mode > 0.10 )	SetThrust( false , true );
			else						SetThrust( false , false );
		}
		
		//回避行動
		private function Pary( tar_x:Number , tar_y:Number , a_drec:int ){
			//敵に狙われているかを判断
			var drec2tar:int = Math.atan2( tar_y - Pos_Y , tar_x - Pos_X ) * 180/Math.PI;
			drec2tar = Utils.fixDrec( drec2tar + 180 );
			//もし敵の射線に入っているようなら垂直に回避する
			var d_dist = Utils.fixDrec( a_drec - drec2tar);
			var pry_d:int;
			if( E_Dist < 150 )	pry_d = 45;
			else				pry_d = 45/(E_Dist/150);
			if( Math.abs( d_dist ) < pry_d ){
				//一定時間以上敵の視界から逃れられない場合は回避方向を逆転させる。
				S_Count++;
				var pry_rev:int = 1;
				if( S_Count >= 10 )	pry_rev = -1;
				if( pry_rev == -1 ){
					if( d_dist < 0 && Pry_Side == 1 ){
						Pry_Rev = 1;
						S_Count = 0;
					}else if( d_dist > 0 && Pry_Side == -1 ){
						Pry_Rev = 1;
						S_Count = 0;
					}
					if( S_Count >=20 )	S_Count = 0;
				}
				//敵のいる方向までのベクトルと垂直に回避する
				var t:Number;
				t = Thrust_X;
				if( d_dist < 0 ){
					Thrust_X = Thrust_Y * pry_rev;
					Thrust_Y = -t * pry_rev;
					Pry_Side = -1;
				}else{
					Thrust_X = -Thrust_Y * pry_rev;
					Thrust_Y = t * pry_rev;
					Pry_Side = 1;
				}
				//推力の再計算
				var b_mode:Number = Math.random();
				if( b_mode < 0.2 )		SetThrust( true , true );
				else if( b_mode < 0.7 )	SetThrust( false , true );
				else					SetThrust( false , false );
			}else{
				S_Count = 0;
			}
		}
		
		//攻撃に関する処理---------------------------------------------------------------------------------------
		//攻撃判定
		public function DecideAttack(){
			if( B_Flag ){
				//武装の設定
				C_Wep = false;
				if( Math.random() > 0.995 )	C_Wep = true;
				//攻撃の判断
				if( Math.random() < AI.B_Type[B_Mode].Attack_Per ){
					Attack = true;
				}else{
					Attack = false;
				}
			}else{
				Attack = false;
			}
		}		
	}
}