package BattleSet{
	import flash.display.Sprite;
	import MiniObj.*;
	import BattleSet.Explodes.*;
	
	public class Battle_Object extends Field_Object{
		protected var mc_Machine:Machine = new Machine();
		
		//ステータス
		public var Name:String;
		public var HP:int;
		public var EN:int;
		
		//エネルギー関係パラメーター
		protected var Charging:Boolean;
		
		//表示位置パラメーター
		public var mc_M_X:int;
		public var mc_M_Y:int;
		
		//射撃関係パラメーター
		public var AttackMode:Boolean;
		public var AttackTime:int;
		//武装関係
		protected var Weapons:Array = new Array();		//装備している武装
		protected var WeaponNow:Array = new Array();	//武装の現在の状態
		protected var SelectWeapon:int;					//現在選択している武装
		//照準関係パラメーター
		protected var Aim_Drec:int;		//狙いをつけている角度
		protected var Aim_X:Number;		//カーソル位置
		protected var Aim_Y:Number;		//カーソル位置
		protected var Drec_LR:int;		//左右の向き
		protected var Reticle_Drec:int;	//照準の方向
		protected var Gun_Drec:int;		//銃口の方向
		public var Target:Array = new Array();	//補足している対象の数
		protected var B_Sys:Array;		//他の機体
		//移動関係パラメーター
		protected var Dash:Boolean;		//ダッシュしている状態か？
		protected var Dash_Time:int;	//ダッシュ開始からの経過時間
		protected var Boost:Boolean;	//ブースターをふかしている状態か？
		
		//照準レティクル
		public var mc_Reticle:Reticle = new Reticle();
		
		//撃破時
		private var mc_Explode:Sprite;	//爆発エフェクト
		private var Ex_Type:int;		//爆発パターン
		
		//コンストラクタ
		public function Battle_Object(){
			Alive = false;
			
			WallSlide = true;
			WallReflect = false;
			//爆発の追加
			mc_Explode = new Explode();
			this.addChild( mc_Explode );
			mc_Explode.visible = false;
		}
		
		//初期化
		protected function BO_Init( parts_data:Array , weapon_data:Array , parts:Array , ex_type:int ){
			//機体の初期化
			mc_Machine.Init( parts_data , weapon_data , parts );
			this.addChild(mc_Machine);
			mc_Machine.visible = true;
			mc_M_X = -mc_Machine.Cen_X;
			mc_M_Y = -mc_Machine.Cen_Y;
			mc_Machine.x = mc_M_X;
			mc_Machine.y = mc_M_Y;
			mc_Machine.scaleX = 1.0;
			mc_Machine.scaleY = 1.0;
			
			//大きさの設定
			Rad = mc_Machine.Rad;
			
			//ステータスの初期化
			Alive = true;
			HP = mc_Machine.MaxHP;
			EN = mc_Machine.EN_Cap;
			Charging = false;
			
			//武器の初期化
			InitWeapon( weapon_data );
			SelectWeapon = 0;
			mc_Machine.ChangeWeapon( SelectWeapon , true );
			//射撃関係パラメーター
			ShotMode = false;
			
			//移動関係パラメーター
			Dash = false;
			Dash_Time = 9999;
			Boost = false;
			
			//爆発関係パラメーター
			Ex_Type = ex_type;
			
			//使用フラグを立てる
			Use = true;
		}
		
		//機体の消去
		public function Close(){
			if( Mode != 0 ){
				mc_Machine.Close();
				this.removeChild(mc_Machine);
				//武器解除
				while( Weapons.length > 0 )	Weapons.pop();
				//ターゲットリセット
				ResetTargets();
				Mode = 0;
				
				mc_Reticle.Reset();
			}
		}
		
		//EN管理----------------------------------------------------------------------------------------
		//EN回復処理
		protected function ChargeEN(){
			EN += mc_Machine.EN_Out;
			if( EN > mc_Machine.EN_Cap ){
				EN = mc_Machine.EN_Cap;
				Charging = false;
			}
		}
		//EN消費処理
		private function UseEN( en:int ){
			if( !Charging ){
				if( EN > en ){
					//使用ENより残りENが大きい場合はEN使用可能
					EN -= en;
					return true;
				}else{
					//ENが少ない場合はENを消費しきってチャージングに
					EN == 0;
					Charging = true;
					return true;
				}
			}
			return false;
		}
		
		//移動に関する処理---------------------------------------------------------------------------------------
		//推力の決定
		protected function CalcThrust( dash:Boolean , boost:Boolean ){
			
			if( dash ){
				if( Dash_Time > 10 ){
					Dash = true;
					Dash_Time = 0;
				}
			}
			
			if( Dash && Dash_Time > 3 )	Dash = false;
			Dash_Time++;
			
			//ブーストの前後方向を決める
			if( Aim_Drec >= -90 && Aim_Drec <= 90 ){
				if( ThrustDrec_X > 0 ){
					CalcThrustF( dash , boost );
				}else{
					CalcThrustB( dash , boost );
				}
			}else{
				if( ThrustDrec_X > 0 ){
					CalcThrustB( dash , boost );
				}else{
					CalcThrustF( dash , boost );
				}
			}
		}
		
		//前方推力処理
		private function CalcThrustF( dash:Boolean , boost:Boolean ){
			thrust_n = mc_Machine.Thrust_N * (12.0 - Math.abs(Speed) )/12.0;
			if( thrust_n < 0.0 )	thrust_n = 0.0;
			
			if( Dash ){
				//ダッシュにENが足りない場合はブーストにする。
				if( UseEN( mc_Machine.EN_DashF ) ){
					Thrust = mc_Machine.DashF + thrust_n;
					Boost = true;
				}else if( UseEN( mc_Machine.EN_BoostF ) ){
					Thrust = mc_Machine.BoostF + thrust_n;
					Boost = true;
				}else{
					Thrust = thrust_n;
					Boost = false;
				}
			}else if(boost){
				if( UseEN( mc_Machine.EN_BoostF ) ){
					Thrust = mc_Machine.BoostF + thrust_n;
					Boost = true;
				}else{
					Thrust = thrust_n;
					Boost = false;
				}
			}else{
				Thrust = thrust_n;
				Boost = false;
			}
		}
		//後方推力処理
		private function CalcThrustB( dash:Boolean , boost:Boolean ){
			thrust_n = mc_Machine.Thrust_N * (12.0 - Math.abs(Speed) )/12.0;
			if( thrust_n < 0.0 )	thrust_n = 0.0;
			
			if( Dash ){
				//ダッシュにENが足りない場合はブーストにする。
				if( UseEN( mc_Machine.EN_DashF ) ){
					Thrust = mc_Machine.DashF + thrust_n;
					Boost = true;
				}else if( UseEN( mc_Machine.EN_BoostF ) ){
					Thrust = mc_Machine.BoostF + thrust_n;
					Boost = true;
				}else{
					Thrust = thrust_n;
					Boost = false;
				}
			}else if(boost){
				if( UseEN( mc_Machine.EN_BoostF ) ){
					Thrust = mc_Machine.BoostF + thrust_n;
					Boost = true;
				}else{
					Thrust = thrust_n;
					Boost = false;
				}
			}else{
				Thrust = thrust_n;
				Boost = false;
			}
		}
		
		
		//照準に関する処理---------------------------------------------------------------------------------------
		//他機体の参照をもらってくる、ターゲット情報初期化
		public function Link_Others( bos:Array ){
			B_Sys = bos;
			var i:int;
			for(i=0 ; i<B_Sys.length ; i++){
				Target[i] = new Target_Unit();
				Target[i].Link_Other( B_Sys[i] );
			}
		}
		
		//ターゲットリセット
		public function ResetTargets(){
			var target_max:int = Target.length;
			for(i=0 ; i<target_max ; i++)	Target[i].Reset();
		}

		//狙いをつけている角度を算出
		public function Decide_Aim( tar_x:Number , tar_y:Number ){
			Aim_Drec = (int)( Math.atan2( tar_y - Pos_Y , tar_x - Pos_X )*180/Math.PI );
			Aim_X = tar_x;
			Aim_Y = tar_y;
			//照準の方向によって向きを設定
			if( Aim_Drec >= -90 && Aim_Drec <= 90 )	Drec_LR = 1;
			else									Drec_LR = -1;
		}
		
		//照準の方向を決定
		public function Decide_Reticle(){
			//もしロックオンのある武器なら
			if( Weapons[SelectWeapon].Aiming != 0 ){
				//照準の修正（制限、ロックオンに対応
				var aim_d:int;
				aim_d = Utils.AdjustDrec( Aim_Drec , Drec_LR );
				if( aim_d > Weapons[SelectWeapon].Movable_Max - Weapons[SelectWeapon].Rock_Drec ){
					Reticle_Drec = Utils.AdjustDrec( Weapons[SelectWeapon].Movable_Max - Weapons[SelectWeapon].Rock_Drec , Drec_LR );
				}else if( aim_d < Weapons[SelectWeapon].Movable_Min + Weapons[SelectWeapon].Rock_Drec ){
					Reticle_Drec = Utils.AdjustDrec( Weapons[SelectWeapon].Movable_Min + Weapons[SelectWeapon].Rock_Drec , Drec_LR );
				}else{
					Reticle_Drec = Aim_Drec;
				}
			}
		}
		
		//ロックオン範囲にいるターゲットの選定
		public function SearchTarget(){
			var i:int;
			var b_sys_max:int = B_Sys.length;
			for( i=0 ; i<b_sys_max ; i++ ){
				//対象ターゲットが使用中で生存中かつ自機と違う陣営ならば
				if( Target[i].retMode() != 0 && Target[i].retAlive() &&Target[i].retMode() != Mode ){
					//ロックオン距離以内か判定
					if( Target[i].CalcDist( Pos_X , Pos_Y , Weapons[SelectWeapon].Rock_Range ) ){
						//ロックオン角度以内か判定
						if( Target[i].CalcDrec( Pos_X , Pos_Y , Reticle_Drec , Weapons[SelectWeapon].Rock_Drec , Drec_LR ) ){
							Target[i].InSight = true;
						}else{
							Target[i].Reset();
						}
					}else{
						Target[i].Reset();
					}
				}else{
					Target[i].Reset();
				}
			}
		}
		
		//指定したターゲットに攻撃方向を向ける
		public function SetGunDrec(){
			var i:int;
			Gun_Drec = Aim_Drec;
			
			//ロックオンカウント段階に入っているターゲットの数を数えると同時にロックオン時間を加算
			var rocking_num:int = 0;
			var target_max:int = Target.length;
			for(i=0 ; i<target_max ; i++){
				if( Target[i].InSight ){
					if( Target[i].Time != -1 ){
						Target[i].Time++;
						if( Target[i].Time >= Weapons[SelectWeapon].Rock_Time )	Target[i].Rocked = true;
						rocking_num++;
					}
				}
			}
			
			//ロックオンカウント段階に入るターゲットが一定数に達するまでカウントを開始（そのうち距離が近いものからにするかも）
			for(i=0 ; i<target_max ; i++){
				if( Target[i].InSight ){
					if( rocking_num >= 1 )	break;
					if( Target[i].Time == -1 ){
						Target[i].Time = 0;
						rocking_num++;
					}
				}
			}
			
			//ロックオンされている対象の一番先頭のものに銃口の方向を決定する
			var ontarget:Boolean = false;
			for(i=0 ; i<target_max ; i++){
				if( Target[i].Rocked ){
					Gun_Drec = Target[i].CalcGunDrec( Pos_X , Pos_Y-15 );
					//Gun_Drec = Target[i].Drec;
					ontarget = true;
					break;
				}
			}
			//ロックオン対象がいない場合カーソル位置を狙う
			if( !ontarget ){
				Gun_Drec = Math.atan2( Aim_Y - (Pos_Y-15) , Aim_X - Pos_X )*180/Math.PI;
			}
			
			//砲塔方向の修正
			var g_drec:int = Utils.AdjustDrec( Gun_Drec , Drec_LR );
			if( g_drec > Weapons[SelectWeapon].Movable_Max ){
				Gun_Drec = Utils.AdjustDrec( Weapons[SelectWeapon].Movable_Max , Drec_LR );
			}else if( g_drec < Weapons[SelectWeapon].Movable_Min ){
				Gun_Drec = Utils.AdjustDrec( Weapons[SelectWeapon].Movable_Min , Drec_LR );
			}
		}

		//一番近い敵の位置を判別、方向を指示する
		public function SetNearTarget():int{
			var min_dist:Number;
			var min_num:int;
			min_dist = 99999999.99;
			
			var i:int;
			var target_max:int = Target.length;
			for(i=0 ; i<target_max ; i++){
				if( Target[i].retMode() != 0 && Target[i].retMode() != Mode ){
					if( Target[i].Dist < min_dist ){
						min_dist = Target[i].Dist;
						min_num = i;
					}
				}
			}
			//一番近い敵と自機との間の角度を計算
			Target[min_num].CalcDrec( Pos_X , Pos_Y , 0,0,0);
			return Target[min_num].Drec;
		}
		
		//攻撃動作関連-------------------------------------------------------------------------------------------
		//武装の初期化
		public function InitWeapon( weapons:Array ){
			var i:int;
			var weapon_max:int = mc_Machine.Weapons.length;
			for( i=0 ; i<weapon_max ; i++ ){
				Weapons[i] = weapons[ mc_Machine.Weapons[i].Data.WepNum ];
				WeaponNow[i] = new Battle_Weapon( weapons[ mc_Machine.Weapons[i].Data.WepNum ] );
			}
		}
		
		//武器の変更
		public function ChangeWeapon(){
			//機体から今まで使用していた武器をリセット
			mc_Machine.ChangeWeapon( SelectWeapon , false );
			mc_Machine.PlayMuzzle( SelectWeapon , 2 );
			AttackMode = false;
			ResetTargets();
			//武装の変更
			SelectWeapon++;
			if( SelectWeapon == Weapons.length )	SelectWeapon = 0;
			//機体に新しく使用する武器をセット
			mc_Machine.ChangeWeapon( SelectWeapon , true );
			
			ShotTime = 0;
		}
		
		//武装のリロード
		protected function Reload(){
			var wepnow_max = WeaponNow.length;
			for( var i:int=0 ; i<wepnow_max ; i++ ){
				WeaponNow[i].Reload();
			}
		}
		
		//攻撃状態のセット
		protected function SetAttack(){
			if( WeaponNow[SelectWeapon].retReload() ){
				if( !AttackMode ){
					AttackTime = 1;
					AttackMode = true;
				}
			}
		}
		
		//攻撃の種類を返す
		public function AttackType():int{
			return Weapons[SelectWeapon].Type;
		}
		
		//弾丸の発射
		public function Shot():Shots{
			//発射される弾丸の情報を返す
			var shots:Shots = new Shots();
			shots.Bullet_Num = 0;		//発射される弾丸の数
			shots.W_Sound.Type = -1;
			
			//射撃中なら
			if( AttackMode ){
				
				//選択している武装のデータを取得する
				//銃口位置の取得
				var gunpos = new Object();
				gunpos = mc_Machine.RetWepPos( SelectWeapon );
				
				//射撃判定
				var i:int,j:int;
				//タイミングが一致したときに射撃する
				for(i=0 ; i<Weapons[SelectWeapon].Blast_Num ; i++){
					if( AttackTime == Weapons[SelectWeapon].Blast[i].Timing ){
						//発射される弾丸の位置や方向を設定する
						shots.Bullets[ shots.Bullet_Num ] = new Shots_Bullet();
						//弾丸のタイプを設定
						shots.Bullets[ shots.Bullet_Num ].Type = Weapons[SelectWeapon].Blast[i].Type;
						//噴射方向の設定
						shots.Bullets[ shots.Bullet_Num ].T_Drec = Gun_Drec +
																 Weapons[SelectWeapon].Blast[i].T_Drec;
						//発射方向の設定
						shots.Bullets[ shots.Bullet_Num ].Drec = Gun_Drec +
																 Weapons[SelectWeapon].Blast[i].Drec + 
																 Math.random() * Weapons[SelectWeapon].Blast[i].Accuracy * 2 - 
																 Weapons[SelectWeapon].Blast[i].Accuracy;
						//初速を設定
						shots.Bullets[ shots.Bullet_Num ].Speed = Weapons[SelectWeapon].Blast[i].Speed;
						//発射位置の決定
						shots.Bullets[ shots.Bullet_Num ].Pos_X = Pos_X + gunpos.X + mc_M_X + 
																  Weapons[SelectWeapon].Blast[i].Length * 
																  Math.cos( shots.Bullets[ shots.Bullet_Num ].Drec * Math.PI/180
																			+ Weapons[SelectWeapon].Blast[i].Rad);
						shots.Bullets[ shots.Bullet_Num ].Pos_Y = Pos_Y + gunpos.Y + mc_M_Y + 
																  Weapons[SelectWeapon].Blast[i].Length * 
																  Math.sin( shots.Bullets[ shots.Bullet_Num ].Drec * Math.PI/180
																			+ Weapons[SelectWeapon].Blast[i].Rad);
						//標的の決定
						shots.Bullets[ shots.Bullet_Num ].Target = -1;
						var target_max = Target.length;
						for( j=0 ; j<target_max ; j++ ){
							if( Target[j].Rocked ){
								shots.Bullets[ shots.Bullet_Num ].Target = j;
								//if( Math.random() > 0.3 )	break;
							}
						}
						shots.Bullet_Num++;
						
						WeaponNow[SelectWeapon].Shot();
					}
				}
				
				//銃口のエフェクトの表示
				for(i=0 ; i<Weapons[SelectWeapon].Muzzle.length ; i++){
					if( AttackTime == Weapons[SelectWeapon].Muzzle[i].Timing ){
						mc_Machine.PlayMuzzle( SelectWeapon , 0 );
					}else{
						mc_Machine.PlayMuzzle( SelectWeapon , 1 );
					}
				}
				
				//サウンドの割り当て
				for( i=0 ; i<Weapons[SelectWeapon].W_Sound.length ; i++ ){
					if( AttackTime == Weapons[SelectWeapon].W_Sound[i].Timing ){
						shots.W_Sound.Volume = Weapons[SelectWeapon].W_Sound[i].Volume;
						shots.W_Sound.Type = Weapons[SelectWeapon].W_Sound[i].Type;
					}
				}
				
				//アクション設定、タイムライン更新
				Action_Attack();
			}
			return shots;
		}
		
		//格闘
		public function InFight(){
			if( AttackMode){
				Action_Attack();
			}
		}
		
		//アクション,タイムラインの加算
		public function Action_Attack(){
			for( var i:int=0 ; i<Weapons[SelectWeapon].Action_Attack.length ; i++ ){
				if( AttackTime == Weapons[SelectWeapon].Action_Attack[i].StartTime ){
					mc_Machine.SetAction( Weapons[SelectWeapon].Action_Attack[i].Type , Weapons[SelectWeapon].Action_Attack[i].MaxTime , false );
				}
			}
			//攻撃経過時間の加算
			AttackTime++;
			if( AttackTime > Weapons[SelectWeapon].Cycle_time  ){
				AttackMode = false;
			}
		}
		
		//ダメージ・破壊系---------------------------------------------------------------------------------------
		//ダメージ処理
		public function Damage( damage:int ):Boolean{
			if(HP - damage <= 0)	HP = 0;
			else 					HP -= damage;
			
			if( Alive && HP == 0){
				SetExplode();
				Alive = false;
				return true;
			}
			return false;
		}

		//機体破壊時のアニメーション処理
		//爆発開始
		public function SetExplode(){
			switch( Ex_Type ){
				case 0:
					mc_Machine.visible = false;
					break;
				case 1:
					break;
			}
			mc_Explode.addExplode( 1 , 0 , 0 , 0 , 2.0 , 3);
			mc_Explode.visible = true;
		}
		//爆発表示
		public function MoveExplode( gap_x:int , gap_y:int ):Boolean{
			if( !mc_Explode.moveExplode( Pos_X + gap_x , Pos_Y + gap_y ) ){
				mc_Explode.visible = false;
				switch( Ex_Type ){
					case 0:
						Close();
						break;
					case 1:
						break;
				}
				return false;
			}
			return true;
		}
		
		//照準関連-------------------------------------------------------------------------------------------
		//照準の初期化
		public function InitReticle(){
			mc_Reticle.RockInit( Target );
			this.addChild( mc_Reticle );
			mc_Reticle.Use = true;
		}
		//照準の表示
		protected function DispReticle(){
			if( mc_Reticle.Use ){
				mc_Reticle.SetSize( Weapons[SelectWeapon].Rock_Range , Weapons[SelectWeapon].Rock_Drec );
				mc_Reticle.SetDrec( Reticle_Drec );
	
				mc_Reticle.DispTarget( -Pos_X , -Pos_Y );
				
				mc_Reticle.SetVector( SetNearTarget() , 0);
			}
		}
		
		//ここから情報取得系--------------------------------------------------------------------------------------
		//機体の最大HPを返す
		public function retMaxHP():int{
			return mc_Machine.MaxHP;
		}
		//機体のHPを返す
		public function retHP():int{
			return HP;
		}
		//機体の最大ENを返す
		public function retMaxEN():int{
			return mc_Machine.EN_Cap;
		}
		//機体のENを返す
		public function retEN():int{
			return EN;
		}
		public function retCharging():Boolean{
			return Charging;
		}
		//現在の武装を返す
		public function retWep():Battle_Weapon{
			return WeaponNow[SelectWeapon];
		}
		//狙いをつけている方向を返す
		public function retAim():int{
			return Aim_Drec;
		}
		//銃口が向いている方向を返す。
		public function retGun():int{
			return Gun_Drec;
		}
		//照準距離を返す
		public function RetRange():int{
			return Weapons[SelectWeapon].Rock_Range;
		}
	}
}