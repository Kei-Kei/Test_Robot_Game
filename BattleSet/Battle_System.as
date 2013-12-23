/*=================================================================================================
Battle_Objectの操作クラス
統合してもよかったけど長くなるので分割
=================================================================================================*/
package BattleSet{
	
	public class Battle_System extends Battle_Object{
		
		public var Control:Boolean;	//プレイヤーが操作可能か？
		
		//AIモードに必要なデータ
		private var AI:AI_Unit = new AI_Unit();	//AI
		
		public function Battle_System(){
			Mode = 0;
		}
		
		//初期化
		public function Init( parts_data:Array , weapon_data:Array , machine_name:String , machine_data:Array ,
							  pos_x:Number , pos_y:Number , mode:int , ex_type:int ){
			//機体部分の初期化
			BO_Init( parts_data , weapon_data , machine_data , ex_type );
			
			//名称の格納
			Name = machine_name;
			
			//位置関係パラメーター
			Pos_X = pos_x;
			Pos_Y = pos_y;
			Speed_X = 0;
			Speed_Y = 0;
			Breaking = 0.75;
			AirRegist = 0.95;
			
			//所属
			Mode = mode;
		}
		
		//手動操作モードの初期化
		public function Manual_Mode_Init(){
			Control = true;
			ThrustDrec_X = 0.0;
			ThrustDrec_Y = 0.0;
		}
		
		//AIモードの初期化
		public function AI_Mode_Init( ai_data:Data_AI , group_data:Data_Enemy_Group ){
			Control = false;
			AI.createAI( ai_data , group_data , B_Sys );
		}
		
		//毎フレームごとの動作を決定する
		public function DecideMove( drec:int , dash:Boolean , boost:Boolean ,
									c_wep:Boolean , mouse_down:Boolean , mouse_x:int , mouse_y:int ){
			if( Alive ){
				//AI動作時
				if( !Control ){
					//ターゲットの選定
					AI.SelectTarget( Mode );
					
					//推進方向の決定
					AI.DecideThrust( Pos_X , Pos_Y , ThrustDrec_X , ThrustDrec_Y , SelectWeapon );
					SetThrustDrec( AI.Thrust_X , AI.Thrust_Y );
					CalcThrust( AI.Dash , AI.Boost );
					
					//照準の策定
					if( AI.AimTarget != -1 ){
						Decide_Aim( B_Sys[AI.AimTarget].Pos_X , B_Sys[AI.AimTarget].Pos_Y );
						Decide_Reticle();
						SearchTarget();
						SetGunDrec();
					}
					
					//武器の選択
					if( AI.C_Wep )	ChangeWeapon();
					//攻撃の判断
					AI.DecideAttack();
					if( AI.Attack )	SetAttack();
				//マニュアル操作時
				}else{
					//推進方向の決定
					var sqrt2_2:Number = Math.SQRT2 / 2;
					switch( drec ){
						case 7:	SetThrustDrec( -sqrt2_2 , -sqrt2_2 );	break;
						case 9:	SetThrustDrec( sqrt2_2 , -sqrt2_2 );	break;
						case 1:	SetThrustDrec( -sqrt2_2 , sqrt2_2 );	break;
						case 3:	SetThrustDrec( sqrt2_2 , sqrt2_2 );		break;
						case 8:	SetThrustDrec( 0.0 , -1.0 );			break;
						case 2:	SetThrustDrec( 0.0 , 1.0 );				break;
						case 4:	SetThrustDrec( -1.0 , 0.0 );			break;
						case 6:	SetThrustDrec( 1.0 , 0.0 );				break;
						//default:SetThrustDrec( 0.0 , 0.0 );				break;
					}
					//推力の決定
					if( drec != -1 || dash ){
						CalcThrust( dash , boost );
					}else{
						Thrust = 0;
					}
					//照準の策定
					Decide_Aim( mouse_x - Utils.Width/2 + Pos_X , mouse_y - Utils.Height/2 + Pos_Y );
					Decide_Reticle();
					SearchTarget();
					SetGunDrec();
					
					//武器の選択
					if( c_wep )	ChangeWeapon();
					//攻撃の判断
					if( mouse_down )	SetAttack();
				}
				//ENの回復
				ChargeEN();
				//武装のリロード
				Reload();
			}else{
				SetThrustDrec( 0.0 , 0.0 );
				CalcThrust( false , false );
			}
		}

		//機体の表示
		public function Disp( gap_x:int , gap_y:int ){
			mc_Machine.x = Pos_X + mc_M_X +gap_x;
			mc_Machine.y = Pos_Y + mc_M_Y +gap_y;
			//戦闘モードあるいは自機と近い場合に機体の描画を行う
			mc_Machine.SetPose( Thrust , ThrustDrec_X , ThrustDrec_Y , Boost , Speed_X , Speed_Y , Aim_Drec , Gun_Drec );
			
			//照準の描画
			DispReticle();
			
			//破壊時の表示
			if( !Alive ){
				MoveExplode( gap_x , gap_y );
			}
		}
	}
}