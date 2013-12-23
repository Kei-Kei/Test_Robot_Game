package{
	import flash.display.Sprite;
	
	public class City_Mission_IF extends Sprite{
		//テンプレート
		public var mc_Back:Sprite = new InterFace_Back01();
		public var mc_BarUp:Sprite = new InterFace_Bar_Up();
		//public var mc_Title:Sprite = new Title_Briefing();
		public var mc_Info:InfoBar = new InfoBar();
		
		//ボタン
		public var bt_BACK:ButtonObj = new ButtonObj();
		
		//ミッション一覧
		private var Selects:Array = new Array();
		private var Select_LoadTime:int;
		private var Mission_Num:Array = new Array();
		
		public function City_Mission_IF(){
			//背景オブジェクト
			this.addChild( mc_Back );
			this.addChild( mc_BarUp );
			mc_BarUp.x = 0;
			mc_BarUp.y = 0;
			/*this.addChild( mc_Title );
			mc_Title.x = -5;
			mc_Title.y = -3;*/
			
			//情報バー
			this.addChild( mc_Info );
			mc_Info.x = 0;
			mc_Info.y = 285;
			
			//ボタン
			bt_BACK.ButtonInit( new IF_BACK() , 460 , 270 );
			this.addChild( bt_BACK );
			
			//ミッションセレクタ
			for( var i:int=0 ; i<=5 ; i++ ){
				Selects[i] = new ButtonObj();
				Selects[i].ButtonInit( new IF_MissionSelect , 20 , i*40 + 35 );
				this.addChild( Selects[i] );
				Selects[i].visible = false;
			}
		}
		
		public function Load(){
			mc_Info.setText("ロード中");
			//セレクタの位置を画面外へ移動しておく
			for( i=0 ; i<6 ; i++ ){
				Selects[i].x = -400;
			}
		}
		
		public function Init( missions:Array ){
			mc_Info.setText("ミッションを選択してください");
			for( i=0 ; i<missions.length ; i++ ){
				Selects[i].mc_Button.Mission_Name.text = missions[i].Name;
				Mission_Num[i] = missions[i].Mis_No;
			}
			//ミッションが表示されるセレクタだけ表示
			for( i=0 ; i<6 ; i++ ){
				if( i < missions.length ){
					Selects[i].visible = true;
				}else{
					Selects[i].visible = false;
				}
				Selects[i].x = -400;
			}
			Select_LoadTime = 0;
		}
		
		public function eF():int{
			var i:int
			//画面遷移時のアニメーション
			for( i=0 ; i<Math.floor(Select_LoadTime/3) ; i++ ){
				Selects[i].x *= 0.7;
			}
			if( Select_LoadTime < 6*3 ){
				Select_LoadTime++;
			}
			
			//情報バーの表示変更
			if( bt_BACK.On )	mc_Info.setText("メインメニューに戻ります");
			else				mc_Info.setText("ミッションを選択してください");
			
			//前の画面に戻る
			if( bt_BACK.Clicked() ){
				return -1;
			}
			
			//ミッション選択の取得
			for( i=0 ; i<Mission_Num.length ; i++ ){
				if( Selects[i].Clicked() ){
					return i;
				}
			}
			return -2;
		}
	}
}
