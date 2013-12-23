package BattleSet{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.getTimer;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.ui.*;
	
	import MyText;
	import ReadyBattle;
	import Basic_Button;
	
	public class Battle extends Sprite{
		//ゲームデータ
		public var Datas:Data_Game = new Data_Game();
		
		//戦闘フィールド
		public var mc_Battle_Field:Battle_Field = new Battle_Field();
		
		//敵データ
		private var Enemy_Groups:Array = new Array();
		
		//ゲーム状態
		//ミッション状態関連
		private var EnemyAlive:Array = new Array();		//指定した敵が生存しているかどうか
		private var EnemyRegene:Array = new Array();	//残りの復活回数
		private var EnemyReady:Array = new Array();		//敵の出撃準備ができているかどうか
		//自機のステータス関連
		private var MyHP:int;
		private var MyMaxHP:int;
		//時間関連
		private var Time:int;				//戦闘開始からの経過時間
		private var StartBattleTime:int;	//戦闘開始時間
		private var BattleMode:String;		//戦闘の状態(開始前：Ready、戦闘中:Now、戦闘終了：End、プレイヤー死亡:Dead)
		private var BeforeTime:int;			//1フレーム前の時間
		
		//各種表示系
		public var Bar_HP:NumBar = new NumBar( 10 , 5 , 120 ,255,200,0 , 0.05);
		public var Bar_EN:NumBar = new NumBar( 10 , 20 , 120 ,128,128,255 , 0.05);
		public var text_Time:MyText = new MyText( Utils.Width/2 - 25 , 5 , "LEFT");
		public var text_Speed:MyText = new MyText( Utils.Width - 60 , 280 , "LEFT" );
		public var Bar_Wep:NumBar = new NumBar( 10 , 285 , 120 , 50,255,50 , 0.50);
		public var Bar_Enemy_HP:NumBar = new NumBar( Utils.Width - 130 , 5 , 120 ,255,0,0 , 0.05);
		
		//入力
		public var IU:InputUnit = new InputUnit();
		
		//コンストラクタ------------------------------------------------------------------------------------------
		public function Battle(){
			this.addChild( mc_Battle_Field );
			//mc_Battle_Field.visible = false;
			
			//各種表示の初期化
			this.addChild( Bar_HP );
			this.addChild( Bar_EN );
			this.addChild( text_Time );
			this.addChild( text_Speed );
			this.addChild( Bar_Wep );
			this.addChild( Bar_Enemy_HP );
			
		}
		
		//初期化------------------------------------------------------------------------------------------
		public function Init( datas:Data_Game , e_groups:Array , map_no:int , my_x:int , my_y:int ){
			//画質の変更
			//stage.quality = StageQuality.HIGH;
			
			//フィールド画面の初期化
			mc_Battle_Field.x = Utils.Width/2;
			mc_Battle_Field.y = Utils.Height/2;
			mc_Battle_Field.scaleX = 1.0;
			mc_Battle_Field.scaleY = 1.0;
			
			//ゲームデータの取得
			Datas = datas;
			
			/*for( var i:int = 0 ; i<Datas.Bullets.length ; i++ ){
				Datas.Bullets[i].RandomSet();
			}*/
			/*for( var i:int = 0 ; i<Datas.Weapons.length ; i++ ){
				Datas.Weapons[i].RandomSet( Datas.Bullets.length );
			}*/
			
			//入力ユニットを追加
			this.addChild( IU );
			mc_Battle_Field.Init( Datas , map_no , my_x,my_y , e_groups );
			
			//敵の初期化
			Enemy_Groups = e_groups;
			var i:int;
			for(i=0 ; i<Enemy_Groups.length ; i++){
				EnemyAlive[i] = -1;
				EnemyRegene[i] = Enemy_Groups[i].Regene_Count;
				EnemyReady[i] = Enemy_Groups[i].Start_Time;
			}
			
			//バトル状態の初期化
			MyHP = mc_Battle_Field.retMyHP();
			MyMaxHP = mc_Battle_Field.retMyMaxHP();
			Time = 0;
			BattleMode = "Stop";
			
		}
		
		//入力初期化------------------------------------------------------------------------------------------
		public function InitInput(){
			//入力初期化
			IU.Init();
		}
		
		//終了処理-------------------------------------------------------------------------------------------
		public function Close(){
			mc_Battle_Field.Close();
			IU.Close();
			this.removeChild( IU );
			while( EnemyAlive.length > 0 ){
				EnemyAlive.pop();
				EnemyReady.pop();
			}
			//画質の変更
			stage.quality = StageQuality.HIGH;
		}
		
		//毎フレームごとの処理-------------------------------------------------------------------------------------
		public function eF_Battle():void{
			
			//敵の出現判定
			encountEnemy();
			
			//キー入力の判定
			IU.SetKeyDrec();
			
			//画面ズーム
			setZoom();
			
			//戦闘を進める
			mc_Battle_Field.disp_Field( BattleMode , IU.keydrec , IU.C_Wep , IU.Dash , IU.Boost , IU.mouse_down , IU.mouse_x , IU.mouse_y );
			IU.C_Wep = false;
			IU.Dash = false;
			
			//機体ステータスの表示
			dispStatus();
			dispEnemyHP();
			
			//経過時間の計算
			if( MyHP > 0 && BattleMode == "Go" ){
				Time = getTimer() - StartBattleTime;
			}
			//経過時間の表示
			dispTime();
			
			BeforeTime = getTimer();
		}
		
		//敵の出現判定-----------------------------------------------------------------------------------------
		private function encountEnemy(){
			var i:int,j:int;
			
			//敵の生存の確認
			for(i=0 ; i<Enemy_Groups.length ; i++){
				if( EnemyAlive[i] >= 0 ){
					//グループに属する敵がすべて破壊された場合復活までのタイマーを起動する
					var e_dead:Boolean = false;
					//for(j=0 ; j<Enemy_Groups[i].AI.length ; j++){
						if( !mc_Battle_Field.RetEnemyAlive( EnemyAlive[i] ) )	e_dead = true;
					//}
					if( e_dead ){
						EnemyAlive[i] = -1;
						EnemyReady[i] = Enemy_Groups[i].Regene_Time;
					}
				}
			}
			
			//敵出現時間をカウントダウン
			for(i=0 ; i<Enemy_Groups.length ; i++){
				if( EnemyAlive[i] == -1 && BattleMode == "Go" ){
					EnemyReady[i] -= getTimer() - BeforeTime;
				}
			}
			
			//時間による敵の追加
			for(i=0 ; i<Enemy_Groups.length ; i++){
				if( EnemyAlive[i] == -1 && EnemyRegene[i] > 0 && EnemyReady[i] <= 0 ){
					//for(j=0 ; j<Enemy_Groups[i].AI.length ; j++){
						var group:Data_Enemy_Group = Enemy_Groups[i];
						var ai:Data_AI = group.AI[j];
						//敵の初期位置を決定する
						var pos_x,pos_y;int;
						switch( group.Start_Type ){
						case 0:
							pos_x = mc_Battle_Field.B_Sys[0].Pos_X + group.Start_Pos_X + Math.random()*group.Start_Dist_X*2 - group.Start_Dist_X;
							pos_y = mc_Battle_Field.B_Sys[0].Pos_Y + group.Start_Pos_Y + Math.random()*group.Start_Dist_Y*2 - group.Start_Dist_Y;
							break;
						case 1:
							pos_x = group.Start_Pos_X + Math.random()*group.Start_Dist_X*2 - group.Start_Dist_X;
							pos_y = group.Start_Pos_Y + Math.random()*group.Start_Dist_Y*2 - group.Start_Dist_Y;
						}
						//敵を追加する
						EnemyAlive[i] = mc_Battle_Field.add_Enemy( Datas.Enemys , group , ai , pos_x , pos_y );
					//}
					//残り出現回数を減らす
					EnemyRegene[i]--;
				}
			}
		}
		
		//戦闘時表示関連----------------------------------------------------------------------------------------
		//機体ステータスの表示
		private function dispStatus(){
			//HPの表示
			MyHP = mc_Battle_Field.retMyHP();
			MyMaxHP = mc_Battle_Field.retMyMaxHP();
			Bar_HP.SetInner( MyHP / MyMaxHP );
			Bar_HP.SetText( "HP:" + MyHP + "/" + MyMaxHP );
			
			//ENの表示
			var en:int = mc_Battle_Field.retMyEN();
			var maxen:int = mc_Battle_Field.retMyMaxEN();
			Bar_EN.SetInner( en / maxen );
			if( mc_Battle_Field.retMyCharging() ){
				Bar_EN.SetText( "EN:CHARGING - " + en + "/" + maxen );
			}else{
				Bar_EN.SetText( "EN:" + en + "/" + maxen );
			}
			
			//速度の表示
			var speed:Number = Math.abs( mc_Battle_Field.retMySpeed() ) * 27;
			text_Speed.dispText( speed.toFixed(0) +"km/h");
			
			//武装の状態の表示
			var wep:Battle_Weapon = mc_Battle_Field.retMyWep();
			Bar_Wep.SetInner( wep.retBar() );
			Bar_Wep.SetText( wep.retText() );
		}
		
		//最後に攻撃を当てた敵のHPを表示
		private function dispEnemyHP(){
			var enename:String = mc_Battle_Field.retEneName(); 
			var enehp:Number = mc_Battle_Field.retEneHP(); 
			if( enehp >= 0 ){
				Bar_Enemy_HP.SetInner(enehp);
				Bar_Enemy_HP.SetText( enename + ": " + Math.floor( enehp * 100 ) + "%");
			}else{
				Bar_Enemy_HP.SetInner(1.0);
				Bar_Enemy_HP.SetText( enename + ":???%");
			}
		}
		
		//時間の表示
		private function dispTime(){
			text_Time.dispText("Time:" + Utils.fixTime(Time));
		}
		
		//画面ズームの変更
		private function setZoom(){
			var range:int = mc_Battle_Field.RetRange();
			var wid:int = Utils.Width;
			if( range < wid/2 ){
				range = wid/2;
			}else if( range > wid*0.9 ){
				range = wid*0.9;
			}
			var z_range:Number = wid/((range*1.10)*2);
			
			mc_Battle_Field.scaleX += ( z_range-mc_Battle_Field.scaleX ) * 0.1;
			mc_Battle_Field.scaleY += ( z_range-mc_Battle_Field.scaleY ) * 0.1;
		}
		
		//ゲーム開始時処理---------------------------------------------------------------------------------------
		public function startBattle(){
			BattleMode = "Go";
			StartBattleTime = getTimer();
		}
		
		//終了関係処理------------------------------------------------------------------------------------------
		
		//終了時の状況を返す。
		public function retResult():Object{
			var res:Object = new Object();
			res.Time = Time;
			MyHP = mc_Battle_Field.retMyHP();
			MyMaxHP = mc_Battle_Field.retMyMaxHP();
			res.HP = MyHP / MyMaxHP * 100;
			return res;
		}
		
		//状況を動かしたりとめたり
		public function Go(){
			BattleMode = "Go";
		}
		public function Stop(){
			BattleMode = "Stop";
		}
		
		//値を返す-------------------------------------------------------------------------------------------
		//自機の生存状態を返す
		public function RetPlayerAlive():Boolean{
			if( MyHP == 0 && BattleMode == "Go" ){
				return true;
			}
		}
		//指定した敵の生存状態を返す
		public function RetEnemyMode( e_num:int ):Boolean{
			if( BattleMode == "Go" ){
				if( EnemyAlive[e_num] == -1 && EnemyRegene[e_num] == 0 )	return false;
			}
			return true;
		}
	}
}