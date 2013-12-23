package GarageSet{
	import flash.display.Sprite;
	
	public class Garage extends Sprite{
		//テンプレート
		public var mc_Back:Sprite = new InterFace_Back01();
		public var mc_BarUp:Sprite = new InterFace_Bar_Up();
		public var mc_Title:Sprite = new Title_Garage();
		public var mc_Info:InfoBar = new InfoBar();
		
		//メニューバー
		private var mc_MenuBar:IconBar;
		
		//ボタン
		public var bt_BACK:ButtonObj = new ButtonObj();
		
		//機体
		private var mc_Machine:Machine = new Machine();
		
		//コンストラクタ
		public function Garage(){
			//背景オブジェクト
			this.addChild( mc_Back );
			this.addChild( mc_BarUp );
			mc_BarUp.x = 0;
			mc_BarUp.y = 0;
			this.addChild( mc_Title );
			mc_Title.x = -5;
			mc_Title.y = -3;
			
			//情報バー
			this.addChild( mc_Info );
			mc_Info.x = 0;
			mc_Info.y = 285;
			
			//ボタン
			bt_BACK.ButtonInit( new IF_BACK() , 460 , 270 );
			this.addChild( bt_BACK );
		}
		
		//初期化
		public function Init( datas:Data_Game , menubar:Sprite ){
			//機体初期化
			mc_Machine.Init( datas.XParts , datas.Weapons , datas.Players[0].Parts );
			mc_Machine.SetAction( 1, 90, true )
			this.addChild(mc_Machine);
			mc_Machine.visible = true;
			mc_Machine.x = 150;
			mc_Machine.y = 150;
			mc_Machine.scaleX = 2.0;
			mc_Machine.scaleY = 2.0;
			
			mc_MenuBar = menubar;
			this.addChild( mc_MenuBar );
		}
		
		//後始末
		public function Close(){
			mc_Machine.Close();
			this.removeChild( mc_Machine );
			this.removeChild( mc_MenuBar );
		}
		
		//毎フレーム処理
		public function eF():int{
			//機体の表示
			mc_Machine.SetPose( 0.0, 0.0, 0.0, false, 0.0, 0.0, 0, 0 );
			
			//情報バーの表示変更
			/*if( bt_BACK.On )	mc_Info.setText("メインメニューに戻ります");
			else				mc_Info.setText("エディットメニューを選択してください");*/
			
			switch( mc_MenuBar.On() ){
				case 0:
					mc_Info.setText("メインメニューに戻ります");
					break;
				default:
					mc_Info.setText("エディットメニューを選択してください");
					break;
			}
			
			//前の画面に戻る
			if( bt_BACK.Clicked() ){
				Close();
				return -1;
			}
			
			return 0;
		}
	}
}