package BattleSet{
	import flash.display.Sprite;
	import flash.events.*;
	
	public class Result extends Sprite{
		public var mc_Back:Sprite = new InterFace_Back01();
		public var mc_BarUp:Sprite = new InterFace_Bar_Up();
		public var mc_Title:Sprite = new Title_Briefing();
		
		//テキスト
		private var mc_TextBox:TextBox = new TextBox(380 , 50);
		public var mc_Info:InfoBar = new InfoBar();
		
		//ボタン
		public var bt_RETRY:ButtonObj = new ButtonObj();
		public var bt_BACK:ButtonObj = new ButtonObj();
		
		public function Result(){
			
			//背景オブジェクト
			this.addChild( mc_Back );
			this.addChild( mc_BarUp );
			mc_BarUp.x = 0;
			mc_BarUp.y = 0;
			this.addChild( mc_Title );
			mc_Title.x = -5;
			mc_Title.y = -3;
			
			//内容
			this.addChild( mc_TextBox );
			mc_TextBox.x = 10;
			mc_TextBox.y = 215;
			//情報バー
			this.addChild( mc_Info );
			mc_Info.x = 0;
			mc_Info.y = 285;
			
			//ボタン
			bt_RETRY.ButtonInit( new IF_RETRY() , 325 , 270 );
			this.addChild( bt_RETRY );
			bt_BACK.ButtonInit( new IF_BACK() , 360 , 270 );
			this.addChild( bt_BACK );
		}
		
		public function Init( mis:Data_Mission , res:Object ){
			
			var rank;
			var t_o:int;
			var h_o:int;
			
			if( mis.Rank_TimeOrder == 0 )	t_o = 1;
			else							t_o = -1;
			if( mis.Rank_HPOrder == 0 )		h_o = 1;
			else							h_o = -1;
			
			if( res.Time * t_o >= mis.Rank[0].Time * t_o	  && res.HP * h_o >= mis.Rank[0].HP * h_o ) rank = "S";
			else if( res.Time * t_o >= mis.Rank[1].Time * t_o && res.HP * h_o >= mis.Rank[1].HP * h_o ) rank = "A";
			else if( res.Time * t_o >= mis.Rank[2].Time * t_o && res.HP * h_o >= mis.Rank[2].HP * h_o ) rank = "B";
			else if( res.Time * t_o >= mis.Rank[3].Time * t_o && res.HP * h_o >= mis.Rank[3].HP * h_o ) rank = "C";
			else rank = "F";
			mc_TextBox.setText("Result:" + 
								 "\n戦闘時間 ： " + Utils.fixTime(res.Time) + 
								 "\n残りＨＰ ： " + res.HP.toFixed(2) + "％" + 
								 "\n評価　　 ： " + rank );

		}
		
		public function eF_Result():int{
			mc_TextBox.ef_TextBox();
			//情報バーの表示変更
			if( bt_RETRY.On )		mc_Info.setText("もう一度ミッションに挑戦します");
			else if( bt_BACK.On )	mc_Info.setText("ミッション一覧に戻ります");
			else					mc_Info.setText("ミッション結果");
			
			if( bt_RETRY.Clicked() ){
				return 1;
			}else if( bt_BACK.Clicked() ){
				return -1;
			}
			return 0;
		}
	}
}