package{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Machine extends Sprite{
		public var mc_Parts:Array = new Array();	//mc
		public var Parts:Array = new Array();		//パーツ構成データ
		public var Weapons:Array = new Array();		//武装割り当てデータ
		
		//ステータス
		public var Cen_X:int;	//機体の重心
		public var Cen_Y:int;	//機体の重心
		public var Rad:int;		//機体の半径
		
		public var Weight:int;
		public var MaxHP:int;				//最大HP
		public var EN_Cap:int;				//EN容量
		public var EN_Out:int;				//EN出力
		public var Thrust_N:Number;			//通常移動推力
		public var BoostF:Number;			//ブースト時推力(前方)
		public var BoostB:Number;			//ブースト時推力(後方)
		public var DashF:Number;			//前方ダッシュ時推力
		public var DashB:Number;			//後方ダッシュ時推力
		public var Dash_Time:int;			//ダッシュ持続時間
		public var Dash_Charge:int;			//次のダッシュまでのチャージ時間
		public var EN_BoostF:int;			//前方ブースト時消費EN
		public var EN_BoostB:int;			//後方ブースト時消費EN
		public var EN_DashF:int;			//前方ダッシュ時消費EN
		public var EN_DashB:int;			//後方ダッシュ時消費EN
		
		public var Drec_LR:int;						//左右の向きを表すデータ
		public var old_Drec_LR:int;
		
		private var WepChanged:int;
		
		private var ActionType:int;					//アクションの種類
		private var ActionTime:int;					//アクション開始からの経過時間
		private var ActionMaxTime:int;				//アクション終了時間
		private var ActionLoop:Boolean;				//アクションがループするかどうか
		
		public function Machine(){
		}
		
		//機体の初期化(パーツデータ　,　機体に装備されているパーツ)
		public function Init( parts_data:Array , weapon_data:Array , parts:Array ){
			
			var i:int,j:int,k:int,m:int,n:int;
			
			Parts = parts;
			
			var p_lib:PartsSkinLib = new PartsSkinLib();
			
			//パーツの構築
			for(i=0,k=0 ; i<parts.length ; i++){
				
				//1パーツ2スキンの時の判定を行う
				var s_num:int;
				if( parts_data[ Parts[i].ID ].Dual ){
					Parts[i].Dual = true;
					s_num = 2;
				}else{
					Parts[i].Dual = false;
					s_num = 1;
				}
				
				//パーツを追加する
				mc_Parts[i] = new Array();
				for(j=0 ; j<s_num ; j++){
					//スキンを追加
					mc_Parts[i][j] = p_lib.retSkin( parts_data[ Parts[i].ID ].Skin );
					this.addChild( mc_Parts[i][j] );
				}
				
				//親パーツの子配列に情報を格納
				if( Parts[i].Parent != -1 ){
					mc_Parts[ Parts[i].Parent ][ Parts[i].ParentLR ].Child.push( i );
				}
				
				//武装情報の構築
				for(m=0 ; m<parts_data[ Parts[i].ID ].WeaponNum ; m++ ){
					//パーツに搭載されている武装
					var weps = new Object();
					weps = parts_data[ Parts[i].ID ].Weapon[m];
					//機体の武器情報に格納する
					Weapons[k] = new Object();
					Weapons[k].Data = weps;	
					Weapons[k].Skin = i;
					//銃口のエフェクトを追加する
					for( n=0 ; n<weapon_data[ weps.WepNum ].Muzzle.length ; n++ ){
						var mzls = new Object();
						mzls = weapon_data[ weps.WepNum ].Muzzle[n];
						for(j=0 ; j<s_num ; j++){
							mc_Parts[i][j].SetMuzzle( mzls.Type , weps.WepSkin , mzls.Pos_X , mzls.Pos_Y , mzls.Drec );
						}
					}
					k++;
				}
			}
			
			SortParts();
			SetColor();
			DispMachine();
			SetStatus( parts_data );
			ResetAction();
		}
		
		//データを閉じる
		public function Close(){
			var i,j:int;
			//パーツ表示のリセット
			for( i=0 ; i<mc_Parts.length ; i++ ){
				for( j=0 ; j<mc_Parts[i].length ; j++){
					this.removeChild( mc_Parts[i][j] );
				}
			}
			//パーツ配列の削除
			while( mc_Parts.length > 0 ){
				mc_Parts.pop();
			}
			//武器配列の削除
			while( Weapons.length > 0 )	Weapons.pop();
		}
		
		//構築系--------------------------------------------------------------------------------------------
		//ステータスの構築
		private function SetStatus( parts_data:Array ){
			
			//数値初期化
			Weight = 0;
			MaxHP = 0;
			EN_Cap = 0;
			EN_Out = 0;
			Thrust_N = 999;
			BoostF = 0;
			BoostB = 0;
			DashF = 0;
			DashB = 0;
			Dash_Time = 999;
			Dash_Charge = 999;
			EN_BoostF = 0;
			EN_BoostB = 0;
			EN_DashF = 0;
			EN_DashB = 0;
			
			var i:int;
			for( i=0 ; i<Parts.length ; i++ ){
				Weight += parts_data[Parts[i].ID].Weight;	//重量
				MaxHP += parts_data[Parts[i].ID].HP;		//HP
				EN_Cap += parts_data[Parts[i].ID].EN_Cap;	//EN容量
				EN_Out += parts_data[Parts[i].ID].EN_Out;	//EN出力
				if( Thrust_N > parts_data[Parts[i].ID].LiftM && parts_data[Parts[i].ID].LiftM != 0){
					Thrust_N = parts_data[Parts[i].ID].LiftM;	//リフター速度
				}
				//ブースト推力
				BoostF += parts_data[Parts[i].ID].BoostF;
				BoostB += parts_data[Parts[i].ID].BoostB;
				//ダッシュ推力
				DashF += parts_data[Parts[i].ID].DashF;
				DashB += parts_data[Parts[i].ID].DashB;
				//消費EN
				EN_BoostF += parts_data[Parts[i].ID].EN_BoostF;
				EN_BoostB += parts_data[Parts[i].ID].EN_BoostB;
				EN_DashF += parts_data[Parts[i].ID].EN_DashF;
				EN_DashB += parts_data[Parts[i].ID].EN_DashB;
			}
			
			BoostF /= Weight;	//前方ブースト推力
			BoostB /= Weight;	//後方ブースト推力
			DashF /= Weight;	//前方ダッシュ推力
			DashB /= Weight;	//後方ダッシュ推力
			
			//機体サイズを計算する
			SetSize();
		}
		
		//機体サイズの構築
		private function SetSize(){
			var x_max:int = 0;
			var x_min:int = 0;
			var y_max:int = 0;
			var y_min:int = 0;
			
			var i:int,j:int;
			var s:int;
			
			//機体の四方向のサイズを求める
			for( i=0 ; i<mc_Parts.length ; i++ ){
				for( j=0 ; j<mc_Parts[i].length ; j++ ){
					s = mc_Parts[i][j].Pos_X + mc_Parts[i][j].Cen_X + mc_Parts[i][j].Rad;
					if( s > x_max )	x_max = s;
					s = mc_Parts[i][j].Pos_X + mc_Parts[i][j].Cen_X - mc_Parts[i][j].Rad;
					if( s < x_min )	x_min = s;
					s = mc_Parts[i][j].Pos_Y + mc_Parts[i][j].Cen_Y + mc_Parts[i][j].Rad;
					if( s > y_max )	y_max = s;
					s = mc_Parts[i][j].Pos_Y + mc_Parts[i][j].Cen_Y - mc_Parts[i][j].Rad;
					if( s < y_min )	y_min = s;
				}
			}
			
			//四方向のサイズから当たり判定用の円サイズを割り出す
			Cen_X = Math.floor( (x_max + x_min)/2 );
			Cen_Y = Math.floor( (y_max + y_min)/2 );
			Rad = Math.floor( (x_max - x_min + y_max - y_min)/4 );
		}
		
		//パーツの表示順を変更
		private function SortParts(){
			var i,j:int;
			
			//レイヤーの階層を決定する
			for( i=0 ; i<mc_Parts.length ; i++ ){
				for( j=0 ; j<mc_Parts[i].length ; j++){
					if( Parts[i].Dual ){
						//左右があるスキンの場合の処理
						if( j == 0 )	mc_Parts[i][j].Layer = Parts[i].Layer * Drec_LR;
						else			mc_Parts[i][j].Layer = -Parts[i].Layer * Drec_LR;
					}else{
						mc_Parts[i][j].Layer = Parts[i].Layer;
						//そのスキンの親に左右があった場合の処理(腕装備武器など)
						if( Parts[i].Parent != -1 ){
							if( Parts[ Parts[i].Parent ].Dual ){
								if( mc_Parts[ Parts[i].Parent ][ Parts[i].ParentLR ].Layer < 0 ){
									mc_Parts[i][j].Layer = Parts[i].Layer * -1;
								}
							}
						}
					}
				}
			}
			
			//レイヤーの順にパーツの上下を並び替える
			var mc_a,mc_b;
			for(i=0 ; i<this.numChildren-1 ; i++){
				for(j=0 ; j<this.numChildren-1-i ; j++){
					mc_a = this.getChildAt( j );
					mc_b = this.getChildAt( j+1 );
					if( mc_a.Layer > mc_b.Layer ){
						this.swapChildrenAt( j , j+1 );
					}
				}
			}
		}
		
		//色をつける
		private function SetColor(){
			var level:int;
			var i,j,m:int;
			for( i=0 ; i<mc_Parts.length ; i++){
				for( j=0 ; j<mc_Parts[i].length ; j++){
					if( Parts[i].Dual ){
						if( mc_Parts[i][j].Layer >= 0 ){
							level = 1;
						}else{
							level = -1;
						}
					}else{
						level = 0;
					}
					for( m=0 ; m<3 ; m++){
						mc_Parts[i][j].SetColor( m+1 , level ,Parts[i].Color[m].R , Parts[i].Color[m].G , Parts[i].Color[m].B );
					}
				}
			}
		}
		
		//色をつけなおす(左右の変化で色が変わるもののみ)
		private function ReSetColor(){
			var level:int;
			var i,j,m:int;
			for( i=0 ; i<mc_Parts.length ; i++){
				for( j=0 ; j<mc_Parts[i].length ; j++){
					if( Parts[i].Dual ){
						if( mc_Parts[i][j].Layer >= 0 ){
							level = 1;
						}else{
							level = -1;
						}
						for( m=0 ; m<3 ; m++){
							mc_Parts[i][j].SetColor( m+1 , level ,Parts[i].Color[m].R , Parts[i].Color[m].G , Parts[i].Color[m].B );
						}
					}
				}
			}
		}
		
		//動作系--------------------------------------------------------------------------------------------
		//機体の表示
		public function DispMachine(){
			var parent,joint:int;
			
			var i:int,j:int;
			var gap_x:Number,gap_y:Number;
			for( i=0 ; i<mc_Parts.length ; i++){
				for( j=0 ; j<mc_Parts[i].length ; j++){
					parent = Parts[i].Parent;
					parentLR = Parts[i].ParentLR;
					joint = Parts[i].Joint;
					
					//二つでひとつのパーツの処理（遠近感をつけるために位置をずらしたりする
					if( Parts[i].Dual ){
						if( mc_Parts[i][j].Layer > 0 ){
							gap_x = -1.5 * Drec_LR;
							gap_y = 0.5;
							mc_Parts[i][j].SetScale( 1.0 );
						}else{
							gap_x = 1.5 * Drec_LR;
							gap_y = -0.5;
							mc_Parts[i][j].SetScale( 0.9 );
						}
					}else{
						gap_x = 0;
						gap_y = 0;
						mc_Parts[i][j].SetScale( 1.0 );
					}
					
					//パーツ位置の設定
					if( parent != -1 && joint != -1 ){
						mc_Parts[i][j].SetPos( mc_Parts[parent][parentLR].Joint_X[joint] + gap_x , mc_Parts[parent][parentLR].Joint_Y[joint] + gap_y );
					}else{
						mc_Parts[i][j].SetPos( 0.0 + gap_x , 0.0 + gap_y );
					}
					//ジョイント位置の設定
					mc_Parts[i][j].SetJoint();
				}
			}
		}
		
		//アクションを設定
		public function SetAction( type:int , maxtime:int, loop:Boolean ){
			if( ActionType == -1 ){
				ActionType = type;
				ActionTime = 0;
				ActionMaxTime = maxtime;
				ActionLoop = loop;
			}
		}
		//アクションのリセット
		public function ResetAction(){
			ActionType = -1;
		}
		
		//機体の向きを調整(推進方向　、速度、進行方向、　狙いをつけている方向　、　武装の方向)
		public function SetPose( thrust:Number , thrust_x:Number , thrust_y:Number , boost:Boolean ,
								 speed_x:Number , speed_y:Number , aim_drec:int , gun_drec:int ){
			//機体が向いている方向を決める
			if( aim_drec >= -90 && aim_drec <= 90 )	Drec_LR = 1;
			else									Drec_LR = -1;
			
			//左右の向きに応じて各方向を調整
			var t_drec:int,a_drec:int,g_drec:int;
			t_drec = Math.floor( Math.atan2( thrust_y , thrust_x ) * 180 / Math.PI );
			t_drec = Utils.AdjustDrec( t_drec , Drec_LR );
			a_drec = Utils.AdjustDrec( aim_drec , Drec_LR );
			g_drec = Utils.AdjustDrec( gun_drec , Drec_LR );
			
			//各パーツのポーズを設定
			var i:int,j:int,k:int,m:int;
			for( i=0 ; i<mc_Parts.length ; i++){
				for( j=0 ; j<mc_Parts[i].length ; j++){
					//親パーツが無い場合パーツの方向を0に設定
					if( Parts[i].Parent == -1 )	mc_Parts[i][j].SetDrec( 0 , Drec_LR );
					//アクション中でない場合
					if( ActionType == -1 ){
						//パーツの状態を設定
						mc_Parts[i][j].SetPose( thrust , t_drec , boost , speed_x*Drec_LR , speed_y , a_drec , g_drec );
					//アクション中の場合
					}else{
						//そのパーツが固有アクションを持っていない場合通常の動作を行う
						if( !mc_Parts[i][j].SetAction( ActionType , ActionTime , ActionMaxTime ) ){
							mc_Parts[i][j].SetPose( thrust , t_drec , boost , speed_x*Drec_LR , speed_y , a_drec , g_drec );
						}
					}
					//そのパーツの子に当たるパーツの方向を設定
					for( k=0 ; k<mc_Parts[i][j].Child.length ; k++ ){
						for( m=0 ; m<mc_Parts[ mc_Parts[i][j].Child[k] ].length ; m++ ){
							mc_Parts[ mc_Parts[i][j].Child[k] ][ m ].SetDrec( mc_Parts[i][j].Drec , Drec_LR );
						}
					}
				}
			}
			
			//左右の向きが変わった場合パーツの順序も入れ替える
			if( Drec_LR != old_Drec_LR ){
				SortParts();
				ReSetColor();
			}
			//武装が変更された次のステップで場合色を設定しなおす（変形パーツがあるため）
			if( WepChanged == 1 ){
				SetColor();
			}
			
			old_Drec_LR = Drec_LR;
			WepChanged--;
			
			//アクション中の場合時間をカウントする
			if( ActionType != -1 ){
				if( ActionTime == ActionMaxTime ){
					if( ActionLoop ){
						ActionTime = 0;
					}else{
						ResetAction();
					}
				}
				ActionTime++;
			}
			
			DispMachine();
		}
		
		//武器を変更した場合の処理
		public function ChangeWeapon( num:int , w_use:Boolean ){
			var w_skin:int = Weapons[num].Skin;
			var i:int;
			for( i=0 ; i<mc_Parts[ w_skin ].length ; i++ ){
				mc_Parts[ w_skin ][i].WepUse[ Weapons[num].Data.WepSkin ] = w_use;
				//親パーツが照準をつける場合,親パーツのモードを変更する(主に腕武器用の例外処理)
				if( mc_Parts[ w_skin ][i].AimType!=0 && mc_Parts[ w_skin ][i].WepUse[ 0 ] != null ){
					if( w_use ){
						switch( mc_Parts[ w_skin ][i].AimType ){
							case 1:
								mc_Parts[ Parts[ w_skin ].Parent ][ Parts[ w_skin ].ParentLR ].Mode = 1;
								break;
							case 2:
								mc_Parts[ Parts[ w_skin ].Parent ][ Parts[ w_skin ].ParentLR ].Mode = 2;
								break;
						}
					}else{
						mc_Parts[ Parts[ w_skin ].Parent ][ Parts[ w_skin ].ParentLR ].Mode = 0;
					}
				}
			}
			WepChanged = 2;
		}
		
		//銃口のエフェクト表示(p_mode：0：再生開始、1：通常再生、2：停止)
		public function PlayMuzzle( num:int , p_mode:int ){
			var w_skin:int = Weapons[num].Skin;
			var i:int;
			for( i=0 ; i<mc_Parts[ w_skin ].length ; i++ ){
				mc_Parts[ w_skin ][ i ].PlayMuzzle( p_mode );
			}
		}
		
		//データ応答系-----------------------------------------------------------------------------------------
		//指定した武装の現在の銃口の位置を返す
		public function RetWepPos( num:int ){
			var pos = new Object;
			if( Weapons[num].Data.WepSkin != -1 ){
				pos.X = mc_Parts[ Weapons[num].Skin ][0].Wep_X[Weapons[num].Data.WepSkin];
				pos.Y = mc_Parts[ Weapons[num].Skin ][0].Wep_Y[Weapons[num].Data.WepSkin];
			}else{
				pos.X = mc_Parts[ Weapons[num].Skin ][0].Pos_X;
				pos.Y = mc_Parts[ Weapons[num].Skin ][0].Pos_Y;
			}
			return pos;
		}
	}
}