package BattleSet{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import Maps.*;
	import MiniObj.*;
	import BattleSet.Explodes.*;
	
	public class Battle_Field extends Sprite{
		
		//マップ
		private var mc_Map = new Map();
		
		//サウンド
		private var Sounds = new Battle_Field_Sounds();
		
		//定数
		private var root2:Number = Math.sqrt(2);
		private var radeg:Number = 180/Math.PI;
		
		//-----ゲーム内変数-----
		//ゲームデータ
		private var Datas:Data_Game = new Data_Game();
		
		//戦闘体
		public var B_Sys:Array = new Array();
		private const B_Sys_Max:int = 11;
		
		//弾丸管理
		private var Bullets:Array = new Array();
		private const Bullets_Max:int = 300;
		
		//爆発管理
		private var Explodes:Array = new Array();
		private const Explode_Max:int = 10;
		
		//その他
		private var LastHit:int;	//最後に攻撃があたった敵の番号
		
		//コンストラクタ----------------------------------------------------------------------------------------
		public function Battle_Field(){
			
			var i:int;
			//MCの追加
			//マップ
			this.addChild( mc_Map );
			//戦闘体初期化
			for(i=0 ; i<B_Sys_Max;  i++){
				B_Sys[i] = new Battle_System();
				this.addChild( B_Sys[i] );
			}
			//弾丸初期化
			for(i=0 ; i<Bullets_Max;  i++){
				Bullets[i] = new Bullet();
				this.addChild( Bullets[i] );
				Bullets[i].visible = false;
			}
			//戦闘体データリンク
			for(i=0 ; i<B_Sys_Max;  i++){
				B_Sys[i].Link_Others( B_Sys );
			}
			
			//爆発エフェクト初期化
			for(i=0 ; i<Explode_Max;  i++){
				Explodes[i] = new Explode();
				this.addChild( Explodes[i] );
				Explodes[i].visible = false;
			}
		}
		
		//初期化--------------------------------------------------------------------------------------------
		public function Init( datas:Data_Game , map_no:int , my_x:int , my_y:int , e_groups:Array ){
			
			//ゲームデータの取得
			Datas = datas;
			
			//マップの初期化
			mc_Map.Init( Datas.Maps[map_no] );
			
			//プレイヤーの初期化
			B_Sys[0].Init( Datas.XParts , Datas.Weapons , "Player" , Datas.Players[0].Parts , my_x,my_y , 1 , 1 );
			//B_Sys[0].AI_Mode_Init( e_groups[0].AI[0], e_groups[0] );//AIモード
			B_Sys[0].Manual_Mode_Init();
			B_Sys[0].InitReticle();
			
			//その他変数初期化
			LastHit = -1;
		}
		
		//終了処理--------------------------------------------------------------------------------------------
		public function Close(){
			
			mc_Map.Close();
			
			var i:int;
			for(i=0 ; i<Bullets_Max ; i++){
				Bullets[i].Close();
				Bullets[i].visible = false;
			}
			//敵の消去
			for(i=0 ; i<B_Sys_Max ; i++){
				B_Sys[i].Close();
			}
			//爆発の消去
			for(i=0 ; i<Explode_Max ; i++){
				if( Explodes[i].Mode != 0 ){
					Explodes[i].visible = false;
				}
			}
		}
		
		//------------------ゲーム内処理------------------
		//毎フレーム処理----------------------------------------------------------------------------------------
		public function disp_Field( b_mode:String , 
								    keydrec:int , c_wep:Boolean , dash:Boolean , boost:Boolean ,
								    mouse_down:Boolean , mouse_x:int , mouse_y:int ){
			
			//当たり判定の計算
			calcHit();
			
			//弾丸移動処理
			move_Bullet();
			
			//戦闘体の表示
			Decide_BSys( keydrec , dash , boost , c_wep , mouse_down , mouse_x , mouse_y );
			if( b_mode == "Go" ){
				Move_BSys();
			}
			Attack_BSys( b_mode );
			Disp_BSys();
			
			//マップ表示
			mc_Map.Disp( -B_Sys[0].Pos_X , -B_Sys[0].Pos_Y );
			
			//弾丸表示
			disp_Bullet();
			
			//爆発表示
			disp_Explode();
			
			//サウンド管理
			Sounds.eF_Sound();
		}
		
		//戦闘体関連処理----------------------------------------------------------------------------------------
		//戦闘体の行動判断
		private function Decide_BSys( keydrec:int , dash:Boolean , boost:Boolean ,
									  c_wep:Boolean , mouse_down:Boolean , mouse_x:int , mouse_y:int){
			var i:int;
			for( i=0 ; i<B_Sys_Max ; i++){
				if( B_Sys[i].Mode != 0 ){
					B_Sys[i].DecideMove( keydrec , dash , boost , c_wep , mouse_down , mouse_x , mouse_y );
				}
			}
		}
		
		//戦闘体の移動
		private function Move_BSys(){
			var i:int;
			for( i=0 ; i<B_Sys_Max ; i++){
				if( B_Sys[i].Mode != 0 ){
					B_Sys[i].CalcSpeed();
					mc_Map.calcHit_Wall( B_Sys[i] );
				}
			}
		}
		//戦闘体の攻撃
		private function Attack_BSys( b_mode:String ){
			var i:int;
			for( i=0 ; i<B_Sys_Max ; i++){
				if( B_Sys[i].Mode != 0 ){
					if( B_Sys[i].Alive){
						if( b_mode == "Go" ){
							switch( B_Sys[i].AttackType() ){
							//射撃処理
							case 0:
								//出現させる弾丸の情報を取得
								var shots:Shots;
								shots = B_Sys[i].Shot();
								var j:int;
								for(j=0 ; j<shots.Bullet_Num ; j++){
									addBullet( B_Sys[i].Mode , shots.Bullets[j] , i);
								}
								if( shots.W_Sound.Type != -1 ){
									Sounds.Play( shots.W_Sound.Type , shots.W_Sound.Volume );
								}
								break;
							//格闘処理
							case 1:
								B_Sys[i].InFight();
								break;
							}
						}
					}
				}
			}
		}
		
		//戦闘体の表示
		private function Disp_BSys(){
			var i:int;
			for( i=0 ; i<B_Sys_Max ; i++){
				if( B_Sys[i].Mode != 0 ){
					B_Sys[i].Disp( -B_Sys[0].Pos_X , -B_Sys[0].Pos_Y );
				}
			}
		}

		//敵関連処理------------------------------------------------------------------------------------------
		//敵の追加
		public function add_Enemy( enemys:Array , group:Data_Enemy_Group , enemy_ai:Data_AI , pos_x:int,pos_y:int ):int{
			var i:int;
			for( i=0 ; i<B_Sys_Max ; i++){
				if( B_Sys[i].Mode == 0 ){
					B_Sys[i].Init( Datas.XParts , Datas.Weapons , Datas.Enemys[enemy_ai.Type].Name , Datas.Enemys[enemy_ai.Type].Parts , pos_x , pos_y , 2 , 0);
					B_Sys[i].AI_Mode_Init( enemy_ai , group );
					return i;
				}
			}
		}
		
		//弾丸関連処理-----------------------------------------------------------------------------------------
		//弾丸の追加
		private function addBullet( mode:int , shot:Shots_Bullet , BS_num:int ){
			var i:int;
			for( i=0 ; i<Bullets_Max ; i++){
				if( Bullets[i].shotBullet( mode , shot , B_Sys[BS_num].Speed_X , B_Sys[BS_num].Speed_Y , Datas.Bullets[shot.Type] ) ){
					Bullets[i].visible = true;	break;
				}
			}
		}
		
		//弾丸の移動処理
		private function move_Bullet(){
			var i:int;
			for( i=0 ; i<Bullets_Max ; i++){
				if( Bullets[i].Mode != 0 && Bullets[i].Alive ){
					//弾丸移動
					if( Bullets[i].Target != -1 ){
						Bullets[i].moveBullet( B_Sys[ Bullets[i].Target ].Pos_X ,  B_Sys[ Bullets[i].Target ].Pos_Y );
					}else{
						Bullets[i].moveBullet( 0 , 0 );
					}
					var c_hit:WallHit = mc_Map.calcHit_Wall( Bullets[i] );
					if( c_hit.Hit ){
						Bullets[i].HitBullet( true );
					}
				}
			}
		}
		
		//弾丸の表示処理
		private function disp_Bullet(){
			var i:int;
			for( i=0 ; i<Bullets_Max ; i++){
				if( Bullets[i].Mode != 0 ){
					//弾丸表示
					var ret_bullet:int = Bullets[i].Disp( -B_Sys[0].Pos_X , -B_Sys[0].Pos_Y );
					//弾丸に変化があるか調査
					if( ret_bullet != 0 ){
						//弾丸を消去するか
						if( ret_bullet < 0 )	Bullets[i].visible = false;
						//爆発を追加するか
						switch( Math.abs(ret_bullet) ){
							case 2:		//消滅時爆発を追加
								add_Explode( Bullets[i].Pos_X , Bullets[i].Pos_Y , Bullets[i].mc_Bullet.rotation , Bullets[i].ExEraseSize() , Bullets[i].ExErase() );
								break;
							case 3:		//命中時爆発を追加
								add_Explode( Bullets[i].Pos_X , Bullets[i].Pos_Y , Bullets[i].mc_Bullet.rotation , Bullets[i].ExHitSize() , Bullets[i].ExHit() );
								break;
							default:	//爆発は追加しない
								break;
						}
					}
				}
			}
		}
		
		//エフェクト関連処理--------------------------------------------------------------------------------------
		//爆発の追加
		private function add_Explode( pos_x:int , pos_y:int , drec:int , size:Number , type:int){
			var i:int;
			if( type != -1 ){
				for( i=0 ; i<Explode_Max ; i++){
					if( Explodes[i].Mode == 0 ){
						Explodes[i].addExplode( 1 , pos_x , pos_y , drec , size , type);
						Explodes[i].visible = true;
						break;
					}
				}
			}
		}
		
		//爆発の表示
		private function disp_Explode(){
			var i:int;
			for( i=0 ; i<Explode_Max ; i++){
				if( Explodes[i].Mode != 0 ){
					//爆発移動
					if( !Explodes[i].moveExplode( -B_Sys[0].Pos_X , -B_Sys[0].Pos_Y ) ){
						Explodes[i].visible = false;
					}
				}
			}
		}

		//計算処理------------------------------------------------------------------------------------------
		//機体と弾丸との当たり判定の計算
		private function calcHit(){
			var far_x:int , far_y:int , rad:int;
			var i:int,j:int;
			for( i=0 ; i<Bullets_Max ; i++){
				if( /*Bullets[i].Mode != 0 &&*/ Bullets[i].Alive ){
					for( j=0 ; j<B_Sys_Max ; j++){
						//機体が使用中の場合のみ
						if( /*B_Sys[j].Mode != 0 &&*/ B_Sys[j].Alive ){
							//機体と弾丸の所属陣営が違う場合のみ
							if( B_Sys[j].Mode != Bullets[i].Mode ){
								if( calcB2B( B_Sys[j] , Bullets[i] ) ){
									if( Bullets[i].HitBullet( false ) ){
										//ダメージ計算
										if( B_Sys[j].Damage( Bullets[i].retDamage() ) ){
											Sounds.Play( 2 , 0.5 );
										}
										//弾が当たった敵の番号を記憶(仮実装)
										if( Bullets[i].Mode == 1 ){
											LastHit = j;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		//当たり判定実際部分
		private function calcB2B( b_sys:Battle_System , bullet:Bullet ):Boolean{
			var px:Number = b_sys.Pos_X - bullet.Pos_X;
			var py:Number = b_sys.Pos_Y - bullet.Pos_Y;
			var dx:Number = b_sys.Speed_X - bullet.Speed_X;
			var dy:Number = b_sys.Speed_Y - bullet.Speed_Y;
			
			var p:Number = dx*dx + dy*dy;	if( p == 0 )	return false;
			var q:Number = px*dx + py*dy;
			var r:Number = px*px + py*py;
			
			var rad:Number = b_sys.Rad + bullet.Rad;
			
			var drad:Number = r-rad*rad;
			//はじめからあたっている場合
			if( drad < 0 ){
				return true;
			}
			
			var judge:Number = q*q - p*( drad );
			
			//衝突していない場合
			if( judge < 0 )		return false;
			
			// 衝突時間の算出
			var t_plus:Number = (-q + Math.sqrt(judge))/p;
			var t_minus:Number = (-q - Math.sqrt(judge))/p;
			
			// 衝突時間が0未満1より大きい場合、衝突しない
			if( (t_plus < 0 || t_plus > 1) && (t_minus < 0 || t_minus > 1) ) return false;
			
			// 衝突位置の決定（t_minus側が常に最初の衝突）
			bullet.Pos_X += bullet.Speed_X * t_minus;
			bullet.Pos_Y += bullet.Speed_Y * t_minus;
			return true; // 衝突報告
		}
		
		//ここから情報取得系--------------------------------------------------------------------------------------
		//自機の最大HPを返す
		public function retMyMaxHP():int{
			return B_Sys[0].retMaxHP();
		}
		//自機のHPを返す
		public function retMyHP():int{
			return B_Sys[0].retHP();
		}
		//自機の最大ENを返す
		public function retMyMaxEN():int{
			return B_Sys[0].retMaxEN();
		}
		//自機のENを返す
		public function retMyEN():int{
			return B_Sys[0].retEN();
		}
		public function retMyCharging():Boolean{
			return B_Sys[0].retCharging();
		}
		//時機の速度を返す
		public function retMySpeed():Number{
			return B_Sys[0].Speed;
		}
		public function retMyWep():Battle_Weapon{
			return B_Sys[0].retWep();
		}
		//最後に弾があたった敵の名称を返す
		public function retEneName():String{
			if( LastHit != -1 ){
				return B_Sys[LastHit].Name;
			}else{
				return "Unknown";
			}
		}
		//最後に弾があたった敵のHPを返す
		public function retEneHP():Number{
			if( LastHit != -1 ){
				return B_Sys[LastHit].retHP() / B_Sys[LastHit].retMaxHP();
			}else{
				return -1.0;
			}
		}
		//自機のロックオン範囲を返す
		public function RetRange():int{
			return B_Sys[0].RetRange();
		}
		//指定した敵が生存しているかを返す
		public function RetEnemyAlive( i:int ){
			return B_Sys[i].Alive;
		}
	}
}