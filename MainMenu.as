package{
	import flash.display.Sprite;
	
	public class MainMenu extends Sprite{
		public var mc_Back:Sprite = new InterFace_Back01();
		public var mc_BarUp:Sprite = new InterFace_Bar_Up();
		
		//テキスト
		private var mc_TextBox:TextBox = new TextBox(380 , 50);
		public var mc_Info:InfoBar = new InfoBar();
		
		//ボタン
		private var bt_Mission:ButtonObj = new ButtonObj();
		private var bt_Garage:ButtonObj = new ButtonObj_S();
		
		//メニューバー
		private var mc_MenuBar:IconBar;
		
		//コンストラクタ
		public function MainMenu(){
			//背景オブジェクト
			this.addChild( mc_Back );
			this.addChild( mc_BarUp );
			mc_BarUp.x = 0;
			mc_BarUp.y = 0;
			
			//情報バー
			this.addChild( mc_Info );
			mc_Info.x = 0;
			mc_Info.y = 285;
		}
		
		//初期化
		public function Init( menubar:Sprite ){
			mc_MenuBar = menubar;
			this.addChild( mc_MenuBar );
		}
		
		//毎フレーム処理
		public function eF():int{
			//
			switch( mc_MenuBar.On() ){
				case 1:
					mc_Info.setText("ミッション選択画面に移行します");
					break;
				case 2:
					mc_Info.setText("機体構成画面に移行します");
					break;
				default:
					mc_Info.setText("");
					break;
			}
			switch( mc_MenuBar.eF() ){
				case 1:
					return 1;
					break;
				case 2:
					return 2;
					break;
				default:
					break;
			}
			return 0;
		}
	}
}