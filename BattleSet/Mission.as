package BattleSet{
	import flash.display.Sprite;
	import flash.events.*;
	
	public class Mission extends Sprite{
		public var OldMode:String,Mode:String;
		private var BattleMode:String;
		
		//子オブジェクト
		public var Window_Briefing:Briefing = new Briefing();
		public var Window_Battle:Battle = new Battle();
		public var Window_Result:Result = new Result();
		
		//ゲームデータ
		public var Datas:Data_Game = new Data_Game();
		public var Mis_Data = new Data_Mission();
		
		//表示系
		public var mc_ReadyBattle:ReadyBattle;
		public var mc_EndBattle:EndBattle;
		
		//コンストラクタ----------------------------------------------------------------------------------------
		public function Mission(){
		}
		
		//初期化--------------------------------------------------------------------------------------------
		public function Init( datas:Data_Game , mis_data:Data_Mission ){
			this.Mode = "Briefing";
			this.OldMode = "";
			
			//ゲームデータの取得
			Datas = datas;
			
			Mis_Data = mis_data;
		}
		
		//現在の状態を判断する-------------------------------------------------------------------------------------
		public function eF_Mission():int{
			//モードの切り替え
			if( Mode != OldMode ){
				switch( Mode ){
				//ブリーフィング画面の表示
				case "Briefing":
					DeleteChildren();
					this.addChild( Window_Briefing );
					Window_Briefing.Init( Mis_Data );
					break;
				//戦闘の初期化
				case "Battle":
					DeleteChildren();
					this.addChild(Window_Battle);
					Window_Battle.Init( Datas , Mis_Data.Groups , Mis_Data.Map_No , Mis_Data.My_X , Mis_Data.My_Y );
					Window_Battle.InitInput();
					BattleMode = "Ready";
					dispReady_Start();
					break;
				//結果画面の表示
				case "Result":
					Window_Result.Init( Mis_Data , Window_Battle.retResult() );
					Window_Battle.Close();
					DeleteChildren();
					this.addChild( Window_Result );
					break;
				}
				OldMode = Mode;
			}
			
			//毎フレーム処理
			switch( Mode ){
				case "Briefing":
					switch( Window_Briefing.eF_Briefing() ){
						case -1:
							return -1;
							break;
						case 1:
							Mode = "Battle";
							break;
					}
					break;
				case "Battle":
					Window_Battle.eF_Battle();
					//自機が破壊されていた場合
					if( Window_Battle.RetPlayerAlive() ){
						BattleMode = "Dead";
						Window_Battle.Stop();
						dispEnd_Start();
					}
					//目標をすべて撃破した場合
					if( !CountTargets() ){
						BattleMode = "Clear";
						Window_Battle.Stop();
						dispEnd_Start();
					}
					
					//開始時、終了時の表示
					dispReady();
					dispEnd();
					break;
				case "Result":
					switch( Window_Result.eF_Result() ){
						case -1:
							return -1;
							break;
						case 1:
							Mode = "Battle";
							break;
					}
					break;
			}
			return 0;
		}
		
		//ミッション進行----------------------------------------------------------------------------------------
		//撃破目標の残存状況を確認
		private function CountTargets():Boolean{
			if( BattleMode == "Now" ){
				var i:int;
				var alive:Boolean = false;
				for( i=0 ; i<Mis_Data.Targets.length ; i++ ){
					if( Window_Battle.RetEnemyMode( Mis_Data.Targets[i] ) )		alive = true;
				}
				return alive;
			}
			return true;
		}
		
		//開始、終了時の表示--------------------------------------------------------------------------------------
		//開始時表示
		//開始処理
		private function dispReady_Start(){
			mc_ReadyBattle = new ReadyBattle();
			this.addChild( mc_ReadyBattle );
			mc_ReadyBattle.x = 200;
			mc_ReadyBattle.y = 150;
		}
		//毎フレーム処理
		private function dispReady(){
			if( BattleMode == "Ready" ){
				//カウントダウンが終了したとき
				if( mc_ReadyBattle.CountDown() ){
					Window_Battle.startBattle();
					BattleMode = "Now";
				}
			}else if( mc_ReadyBattle.alpha != 0 ){
				mc_ReadyBattle.alpha *= 0.8;
				if( mc_ReadyBattle.alpha < 0.05){
					mc_ReadyBattle.alpha = 0;
					this.removeChild( mc_ReadyBattle );
				}
			}
		}
		
		//終了時表示
		//開始処理
		private function dispEnd_Start(){
			mc_EndBattle = new EndBattle();
			this.addChild( mc_EndBattle );
			mc_EndBattle.x = 200;
			mc_EndBattle.y = 150;
		}
		//毎フレーム処理
		private function dispEnd(){
			//終了処理
			if( BattleMode == "Clear" || BattleMode == "Dead" ){
				//終了表示が終了したとき
				if( mc_EndBattle.CountDown() ){
					this.removeChild( mc_EndBattle );
					Mode = "Result";
				}
			}
		}
		
		//子オブジェクトの削除-------------------------------------------------------------------------------------
		private function DeleteChildren(){
			var i:int;
			for( i=0 ; i<this.numChildren ; i++){
				this.removeChildAt(0);
			}
		}
	}
}