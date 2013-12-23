package BattleSet{
	import flash.display.Sprite;
	import flash.events.*;
	
	public class Briefing extends Sprite{
		public var mc_Back:Sprite = new InterFace_Back01();
		public var mc_BarUp:Sprite = new InterFace_Bar_Up();
		public var mc_Title:Sprite = new Title_Briefing();
		
		//テキスト
		private var mc_TextBox:TextBox = new TextBox(480 , 50);
		public var mc_Info:InfoBar = new InfoBar();
		
		//ボタン
		public var bt_GO:ButtonObj = new ButtonObj();
		public var bt_CANCEL:ButtonObj = new ButtonObj();
		
		//コンストラクタ
		public function Briefing(){
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
			bt_GO.ButtonInit( new IF_GO() , 425 , 270 );
			this.addChild( bt_GO );
			bt_CANCEL.ButtonInit( new IF_CANCEL() , 460 , 270 );
			this.addChild( bt_CANCEL );
		}
		//初期化
		public function Init( mis:Data_Mission ){
			mc_TextBox.setText( mis.Text );
		}
		
		public function eF_Briefing():int{
			mc_TextBox.ef_TextBox();
			//情報バーの表示変更
			if( bt_GO.On )		mc_Info.setText("出撃します。");
			else if( bt_CANCEL.On )	mc_Info.setText("ミッション一覧に戻ります");
			else				mc_Info.setText("ミッション内容を確認してください");
			
			if( bt_GO.Clicked() ){
				return 1;
			}else if( bt_CANCEL.Clicked() ){
				return -1;
			}
			return 0;
		}
	}
}