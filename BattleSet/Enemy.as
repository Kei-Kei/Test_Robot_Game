package BattleSet{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import Explodes.*;
	
	public class Enemy extends Player{
		
		//敵の行動
		public var Group:Data_Enemy_Group = new Data_Enemy_Group();
		public var AI:Data_AI = new Data_AI();
		//戦闘モード
		public var B_Mode:int;
		//戦闘中かどうかのフラグ
		public var B_Flag:Boolean;
		//
		private var E_Dist:Number;	//敵との距離
		public var S_Count:int;		//敵の視界内に捕らえられたカウント
		public var Pry_Side:int;
		
		//死亡時爆発エフェクト（仮設
		public var mc_DeadExplode:Sprite;
		
		//コンストラクタ
		public function Enemy(){
			//爆発の追加
			mc_DeadExplode = new Explode();
			this.addChild( mc_DeadExplode );
			mc_DeadExplode.visible = false;
		}
		
		//敵の生成
		public function createEnemy( parts_data:Array , weapon_data:Array ,
									 enemys:Array , group:Data_Enemy_Group , ai_data:Data_AI , 
									 pos_x:int , pos_y:int ){
			Group = group;
			AI = ai_data;
			B_Mode = 0;
			S_Count = 0;
			Pry_Side = 1;
			
			BO_Init( parts_data , weapon_data , enemys[AI.Type].Parts );
			SelectWeapon = 0;
			
			//位置関係パラメーター
			Pos_X = pos_x;
			Pos_Y = pos_y;
			Speed_X = 0;
			Speed_Y = 0;
			DownSpeed = 0.80;
		}
		
		//移動に関する処理---------------------------------------------------------------------------------------
		//敵の移動
		public function DecideThrust( player_x:Number , player_y:Number , a_drec:int ){
			
			//戦闘モードかどうかを判定
			var dist_x:Number  = player_x - Group.Area_Cen_X;
			var dist_y:Number  = player_y - Group.Area_Cen_Y;
			var dist:Number = Math.sqrt( dist_x * dist_x + dist_y * dist_y );
			if( B_Flag ){
				//追跡範囲内から敵が出た場合戦闘モードを解除する
				if( dist > Group.Area_H_Range )	B_Flag = false;
			}else{
				//索敵範囲内に敵が侵入した場合戦闘モードを起動する
				if( dist < Group.Area_S_Range )	B_Flag = true;
			}
			
			//戦闘モードならば
			if( B_Flag ){
				//推力方向の決定
				switch( AI.B_Type[B_Mode].Battle_Type ){
				case 0:	//NearPlayer
					Trace_Point( player_x , player_y );
					break;
				case 1:	//Fix
					Trace_Point( AI.B_Type[B_Mode].Battle_Cen_X , AI.B_Type[B_Mode].Battle_Cen_Y );
					break;
				}
				//回避行動
				if( Math.random() < 1.0 ) Pary( player_x , player_y , a_drec );
				//武装の変更
				if( Math.random() > 0.995 )	ChangeWeapon();
			}else{
				if( dist < 1000 ){
					Trace_Point( Group.Area_Cen_X , Group.Area_Cen_Y);
				}else{
					Thrust = 0;
				}
			}
		}
		
		//プレイヤーに追従する動き
		private function Trace_Point( pt_x:Number , pt_y:Number){
			
			//目標の位置に応じて推進方向を決定
			var sx:Number = pt_x - Pos_X;
			var sy:Number = pt_y - Pos_Y;
			E_Dist = Math.sqrt( sx*sx + sy*sy );
			var dist2:Number;
			if( E_Dist != 0 )	dist2 = 1/E_Dist;
			else			dist2 = E_Dist;
			Thrust_Drec.x = sx*dist2;
			Thrust_Drec.y = sy*dist2;
			//目標と保つべき距離より近かったら目標から遠ざかる
			if( E_Dist - AI.B_Type[B_Mode].Battle_Range < 0 ){
				Thrust_Drec.x *= -1;
				Thrust_Drec.y *= -1;
			}
			
			//目標との距離に応じて速度を変更
			var b_mode:Number = Math.random();
			if( E_Dist < AI.B_Type[B_Mode].Battle_Range + AI.B_Type[B_Mode].Battle_Frac ){
				if( b_mode > 0.99 )			CalcThrust( true , true );
				else if( b_mode > 0.95 )	CalcThrust( false , true );
				else						CalcThrust( false , false );
			}else{
				if( b_mode > 0.95 )			CalcThrust( true , true );
				else						CalcThrust( false , true );
			}
			
		}
		
		//回避行動
		private function Pary( ply_x:Number , ply_y:Number , a_drec:int ){
			//敵に狙われているかを判断
			var drec2ply:int = Math.atan2( ply_y - Pos_Y , ply_x - Pos_X ) * 180/Math.PI;
			drec2ply = Utils.fixDrec( drec2ply + 180 );
			//もし敵の射線に入っているようなら垂直に回避する
			var d_dist = Utils.fixDrec( a_drec - drec2ply );
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
				t = Thrust_Drec.x;
				if( d_dist < 0 ){
					Thrust_Drec.x = Thrust_Drec.y * pry_rev;
					Thrust_Drec.y = -t * pry_rev;
					Pry_Side = -1;
				}else{
					Thrust_Drec.x = -Thrust_Drec.y * pry_rev;
					Thrust_Drec.y = t * pry_rev;
					Pry_Side = 1;
				}
				//推力の再計算
				var b_mode:Number = Math.random();
				if( b_mode < 0.2 )		CalcThrust( true , true );
				else if( b_mode < 0.7 )	CalcThrust( false , true );
				else					CalcThrust( false , false );
			}else{
				S_Count = 0;
			}
		}
		
		//敵の攻撃判定
		public function Attack(){
			if( B_Flag ){
				if( Math.random() < AI.B_Type[B_Mode].Attack_Per ){
					if( !ShotMode ){
						ShotTime = 0;
						ShotMode = true;
					}
				}
			}
		}
		
		//-----------------------------------------------------------------------------------------------
		//敵の表示
		public function Disp( gap_x:int , gap_y:int ){
			mc_Machine.x = Pos_X + mc_M_X +gap_x;
			mc_Machine.y = Pos_Y + mc_M_Y +gap_y;
			//戦闘モードあるいは自機と近い場合に機体の描画を行う
			if( B_Flag ){
				mc_Machine.SetPose( Thrust , Thrust_Drec , Boost , Speed_X , Speed_Y , Aim_Drec , Gun_Drec );
			}else if( Math.abs( Pos_X + gap_x ) < 300 ){
				if( Math.abs( Pos_Y + gap_y ) < 250 ){
					mc_Machine.SetPose( Thrust , Thrust_Drec , Boost , Speed_X , Speed_Y , Aim_Drec , Gun_Drec );
				}
			}
		}
		
		//機体破壊時のアニメーション処理
		public function E_Destoroy( gap_x:int , gap_y:int ):Boolean{
			if( DestoroyTime == 0 ){
				mc_Machine.visible = false;
				mc_DeadExplode.addExplode( Pos_X , Pos_Y , 1.3 , 2);
				mc_DeadExplode.visible = true;
				DestoroyTime = 1;
			}
			if( !mc_DeadExplode.moveExplode( gap_x , gap_y ) ){
				mc_DeadExplode.visible = false;
				Close();
			}
		}
	}
}