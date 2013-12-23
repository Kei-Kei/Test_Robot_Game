package{
	
	public class Data_Weapon{
		//基本データ
		public var Category:String;			//カテゴリ
	
		//-----火器管制-----
		public var Aiming:int;				//照準　0:マニュアル　1:セミオート　2:フルオート
		public var FSS_Flag:Boolean;		//偏差射撃　ON　OFF
		public var Rock_Time:int;			//ロックオン時間
		public var Rock_Range:int;			//ロックオン可能距離
		public var Rock_Drec:int;			//ロックオン可能角度
		public var Shot_Pattern:int;		//射撃　マニュアル　セミオート
		public var Auto_shot:int;			//自律攻撃　無し　連動　自動
		public var Multi_Rock_Num:int;		//同時ロックオン数
		
		//-----武器タイプ-----
		public var Type:int;				//武器タイプ(0:射撃武器、1:格闘武器)

		//-----弾薬管理-----
		public var MagAmmo:int;				//弾倉容量
		public var MaxMag:int;				//弾倉数
		public var Cycle_Ammo:int;			//1サイクルで消費する弾数
		public var Cycle_Ene:int;			//1サイクルで消費するエネルギー
		public var Reload_Time:int;			//リロード時間
		
		//-----タイムライン-----
		public var Cycle_time:int;			//１サイクルの時間
		
		//-----砲塔設定(射撃武器)-----
		public var Movable_Min:int;			//最小稼動範囲（-360～360）
		public var Movable_Max:int;			//最大可動範囲（-360～360）
		public var Blast_Num:int;			//発射パターン数（1～20）
		public var Blast:Array = new Array();	//発射パターン
		public var Muzzle:Array = new Array();	//銃口エフェクト
		
		//-----設定(格闘武器)-----
		
		//-----アクション-----
		public var Action_Attach:Array = new Array();	//武器を構えるとき
		public var Action_Remove:Array = new Array();	//武器をはずすとき
		public var Action_Attack:Array = new Array();	//攻撃時
		
		//サウンド
		public var W_Sound:Array = new Array();	//サウンド
		
		
		//コンストラクタ
		public function Data_Weapon(){
		}
		
		//データの構築
		public function Build( newdata:XML ){
			var i:int,j:int;
			//基本データ
			Category = newdata.Category;			//カテゴリ
		
			//-----火器管制-----
			Aiming = newdata.Aiming;				//照準　0:マニュアル　1:セミオート　2:フルオート
			FSS_Flag = Utils.itoB( newdata.FSS_Flag );	//偏差射撃　ON　OFF
			Rock_Time = newdata.Rock_Time;			//ロックオン時間
			Rock_Range = newdata.Rock_Range;		//ロックオン可能距離
			Rock_Drec = newdata.Rock_Drec;			//ロックオン可能角度
			Shot_Pattern = newdata.Shot_Pattern;	//射撃　マニュアル　セミオート
			Auto_shot = newdata.Auto_shot;			//自律攻撃　無し　連動　自動
			Multi_Rock_Num = newdata.Multi_Rock_Num;//同時ロックオン数
			
			//-----武器タイプ-----
			Type = newdata.Type;					//武器タイプ(0:射撃武器、1:格闘武器)

			//-----弾薬管理-----
			MagAmmo = newdata.MagAmmo;				//弾倉容量
			MaxMag = newdata.MaxMag;				//弾倉数
			Cycle_Ammo = newdata.Cycle_Ammo;		//1サイクルで消費する弾数
			Cycle_Ene = newdata.Cycle_Ene;			//1サイクルで消費するエネルギー
			Reload_Time = newdata.Reload_Time;		//リロード時間			
			
			//-----タイムライン-----
			Cycle_time = newdata.Cycle_time;		//１サイクルの時間
			
			//-----砲塔設定-----
			Movable_Min = newdata.Movable_Min;		//最小稼動範囲（-360～360）
			Movable_Max = newdata.Movable_Max;		//最大可動範囲（-360～360）
			Blast_Num = 0;							//発射パターン数を初期化
			
			//-----発射パターン-----
			for( i=0 ; i<newdata.Blast.length() ; i++){
				for( j=0 ; j< newdata.Blast[i].Copy ; j++ ){
					Blast[Blast_Num] = new Data_Blast();
					Blast[Blast_Num].Accuracy = newdata.Blast[i].Accuracy;	//発射精度
					Blast[Blast_Num].T_Drec = newdata.Blast[i].T_Drec;		//噴射方向
					Blast[Blast_Num].Drec = newdata.Blast[i].Drec;			//射出方向
					Blast[Blast_Num].Speed = newdata.Blast[i].Speed;		//初速
					Blast[Blast_Num].Pos_X = newdata.Blast[i].Pos_X;		//発射位置
					Blast[Blast_Num].Pos_Y = newdata.Blast[i].Pos_Y;		//発射位置
					Blast[Blast_Num].Length = Math.sqrt( Math.pow( newdata.Blast[i].Pos_X , 2 ) + Math.pow( newdata.Blast[i].Pos_Y , 2 ) );	//極座標計算
					Blast[Blast_Num].Rad = Math.atan2( newdata.Blast[i].Pos_Y , newdata.Blast[i].Pos_X );	//極座標計算
					Blast[Blast_Num].Timing = int(newdata.Blast[i].Timing) + int(newdata.Blast[i].D_Timing) * j;	//発射タイミング
					Blast[Blast_Num].Type = newdata.Blast[i].Type;			//発射弾
					//発射パターン数をカウント
					Blast_Num++;
				}
			}
			
			//-----銃口エフェクト-----
			for( i=0 ; i<newdata.Muzzle.length() ; i++ ){
				Muzzle[i] = new Object();
				Muzzle[i].Drec = newdata.Muzzle[i].Drec;
				Muzzle[i].Pos_X = newdata.Muzzle[i].Pos_X;		//発射位置
				Muzzle[i].Pos_Y = newdata.Muzzle[i].Pos_Y;		//発射位置
				Muzzle[i].Timing = newdata.Muzzle[i].Timing;
				Muzzle[i].Type = newdata.Muzzle[i].Type;
			}
			
			//-----アクション-----
			for( i=0 ; i<newdata.Action_Attach.Action.length() ; i++ ){
				Action_Attach[i] = new Data_Action();
				Action_Attach[i].Type = newdata.Action_Attach.Action[i].Type;
				Action_Attach[i].StartTime = newdata.Action_Attach.Action[i].StartTime;
				Action_Attach[i].MaxTime = newdata.Action_Attach.Action[i].MaxTime;
			}
			for( i=0 ; i<newdata.Action_Remove.Action.length() ; i++ ){
				Action_Remove[i] = new Data_Action();
				Action_Remove[i].Type = newdata.Action_Remove.Action[i].Type;
				Action_Remove[i].StartTime = newdata.Action_Remove.Action[i].StartTime;
				Action_Remove[i].MaxTime = newdata.Action_Remove.Action[i].MaxTime;
			}
			for( i=0 ; i<newdata.Action_Attack.Action.length() ; i++ ){
				Action_Attack[i] = new Data_Action();
				Action_Attack[i].Type = newdata.Action_Attack.Action[i].Type;
				Action_Attack[i].StartTime = newdata.Action_Attack.Action[i].StartTime;
				Action_Attack[i].MaxTime = newdata.Action_Attack.Action[i].MaxTime;
			}
			
			//-----サウンド-----
			for( i=0 ; i<newdata.Sound.length() ; i++ ){
				W_Sound[i] = new Data_Weapon_Sound();
				W_Sound[i].Timing = newdata.Sound[i].Timing;
				W_Sound[i].Volume = newdata.Sound[i].Volume;
				W_Sound[i].Type = newdata.Sound[i].Type;
			}
		}
		
		//ランダムセット
		public function RandomSet( bulletnum:int ){
			var i:int,j:int;
			
			//-----火器管制-----
			Aiming = Math.floor(Math.random()*3);				//照準　0:マニュアル　1:セミオート　2:フルオート
			FSS_Flag = Utils.itoB( Math.floor(Math.random()*2) );	//偏差射撃　ON　OFF
			Rock_Time = Math.floor(Math.random()*20);			//ロックオン時間
			Rock_Range = Math.floor(Math.random()*500);			//ロックオン可能距離
			Rock_Drec = Math.floor(Math.random()*180);			//ロックオン可能角度
			Shot_Pattern = Math.floor(Math.random()*2);			//射撃　マニュアル　セミオート
			Auto_shot = Math.floor(Math.random()*3);			//自律攻撃　無し　連動　自動
			Multi_Rock_Num = Math.floor(Math.random()*6)+1;		//同時ロックオン数
			
			//-----武器タイプ-----
			Type = 0;					//武器タイプ(0:射撃武器、1:格闘武器)

			//-----弾薬管理-----
			MagAmmo = Math.floor(Math.random()*200);			//弾倉容量
			MaxMag = Math.floor(Math.random()*50);				//弾倉数
			Cycle_Ammo = 1;										//1サイクルで消費する弾数
			Cycle_Ene = Math.floor(Math.random()*100);			//1サイクルで消費するエネルギー
			Reload_Time = Math.floor(Math.random()*100);		//リロード時間			
			
			//-----タイムライン-----
			Cycle_time = Math.floor(Math.random()*50) + 1;			//１サイクルの時間
			
			//-----砲塔設定-----
			Movable_Min = Math.floor(Math.random()*360) - 180;				//最小稼動範囲（-360～360）
			Movable_Max = Math.floor(Math.random()*(180 - Movable_Min)) + Movable_Min;		//最大可動範囲（-360～360）
			Blast_Num = 0;							//発射パターン数を初期化
			
			//-----発射パターン-----
			//発射パターン数のリセット
			for( i=0 ; i<Blast.length ; i++){
				Blast.pop();
			}
			var lenblast:int = Math.floor(Math.random()*10);
			//発射パターンの設定
			for( i=0 ; i<lenblast ; i++){
				var cpblast:int = Math.floor(Math.random()*10);
				for( j=0 ; j<cpblast ; j++ ){
					Blast[Blast_Num] = new Data_Blast();
					Blast[Blast_Num].Accuracy = Math.floor(Math.random()*10);	//発射精度
					Blast[Blast_Num].T_Drec = Math.floor(Math.random()*360);	//噴射方向
					Blast[Blast_Num].Drec = Math.floor(Math.random()*360);		//射出方向
					Blast[Blast_Num].Speed = Math.floor(Math.random()*100);		//初速
					Blast[Blast_Num].Pos_X = Math.floor(Math.random()*20)-10;	//発射位置
					Blast[Blast_Num].Pos_Y = Math.floor(Math.random()*20)-10;	//発射位置
					Blast[Blast_Num].Length = Math.sqrt( Math.pow( Blast[Blast_Num].Pos_X , 2 ) + Math.pow( Blast[Blast_Num].Pos_Y , 2 ) );	//極座標計算
					Blast[Blast_Num].Rad = Math.atan2( Blast[Blast_Num].Pos_Y , Blast[Blast_Num].Pos_X );	//極座標計算
					Blast[Blast_Num].Timing = Math.floor(Math.random()*Cycle_time);	//発射タイミング
					Blast[Blast_Num].Type = Math.floor(Math.random()*bulletnum);			//発射弾
					//発射パターン数をカウント
					Blast_Num++;
				}
			}
			
			//-----銃口エフェクト-----
			/*for( i=0 ; i<newdata.Muzzle.length() ; i++ ){
				Muzzle[i] = new Object();
				Muzzle[i].Drec = newdata.Muzzle[i].Drec;
				Muzzle[i].Pos_X = newdata.Muzzle[i].Pos_X;		//発射位置
				Muzzle[i].Pos_Y = newdata.Muzzle[i].Pos_Y;		//発射位置
				Muzzle[i].Timing = newdata.Muzzle[i].Timing;
				Muzzle[i].Type = newdata.Muzzle[i].Type;
			}*/
			
			//-----アクション-----
			/*for( i=0 ; i<newdata.Action_Attach.Action.length() ; i++ ){
				Action_Attach[i] = new Data_Action();
				Action_Attach[i].Type = newdata.Action_Attach.Action[i].Type;
				Action_Attach[i].StartTime = newdata.Action_Attach.Action[i].StartTime;
				Action_Attach[i].MaxTime = newdata.Action_Attach.Action[i].MaxTime;
			}
			for( i=0 ; i<newdata.Action_Remove.Action.length() ; i++ ){
				Action_Remove[i] = new Data_Action();
				Action_Remove[i].Type = newdata.Action_Remove.Action[i].Type;
				Action_Remove[i].StartTime = newdata.Action_Remove.Action[i].StartTime;
				Action_Remove[i].MaxTime = newdata.Action_Remove.Action[i].MaxTime;
			}
			for( i=0 ; i<newdata.Action_Attack.Action.length() ; i++ ){
				Action_Attack[i] = new Data_Action();
				Action_Attack[i].Type = newdata.Action_Attack.Action[i].Type;
				Action_Attack[i].StartTime = newdata.Action_Attack.Action[i].StartTime;
				Action_Attack[i].MaxTime = newdata.Action_Attack.Action[i].MaxTime;
			}*/
			
			//-----サウンド-----
			/*for( i=0 ; i<newdata.Sound.length() ; i++ ){
				W_Sound[i] = new Data_Weapon_Sound();
				W_Sound[i].Timing = newdata.Sound[i].Timing;
				W_Sound[i].Volume = newdata.Sound[i].Volume;
				W_Sound[i].Type = newdata.Sound[i].Type;
			}*/
		}
	}
}