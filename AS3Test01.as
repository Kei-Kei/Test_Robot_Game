package{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.getTimer;
	import BattleSet.*;
	import GarageSet.*;
	
	public class AS3Test01 extends Sprite{
		//タイムライン
		public var OldMode:String,Mode:String;
		
		//各画面
		private var Window_PreLoader:Sprite;
		private var Window_MainMenu:MainMenu = new MainMenu();
		private var Window_City_Mission:City_Mission = new City_Mission();
		private var Window_Garage:Garage = new Garage();
		
		//ゲームデータ
		private var Datas:Data_Game = new Data_Game();
		
		//メニューバー
		private var mc_MenuBar = new IconBar();
		
		//FPS表示
		public var text_FPS:Sprite = new text_Tiny();
		public var count_FPS:int = 0;
		public var time_FPS:int;
		
		//初期化--------------------------------------------------------------------------------------------
		public function AS3Test01(){
			
			//FPS表示を追加
			this.addChild( text_FPS );
			text_FPS.x = 450;
			text_FPS.y = 292;
			time_FPS = getTimer();
			
			//タイムラインの追加
			this.addEventListener( Event.ENTER_FRAME , eF_MyTimeLine );
			
			mc_MenuBar.Init();
			mc_MenuBar.y = 20;
			Window_MainMenu.Init( mc_MenuBar );
			
			this.Mode = "Loading";
			
		}
		
		//現在の状態を判断する----------------------------------------------------------------------------------
		public function eF_MyTimeLine(e:Event){
			
			//FPS計算
			count_FPS++;
			if( count_FPS == 30 ){
				var fps:Number = 30000 / (getTimer() - time_FPS)
				text_FPS.Text.text = "FPS:" + fps.toFixed(1);
				time_FPS = getTimer();
				count_FPS = 0;
			}
			
			//モード切替
			if( Mode != OldMode ){
				//後処理
				switch( OldMode ){
					case "Loading":
						this.removeChild( Window_PreLoader );
						break;
					case "Menu":
						this.removeChild( Window_MainMenu );
						break;
					case "City":
						this.removeChild( Window_City_Mission );
						break;
					case "Garage":
						this.removeChild( Window_Garage );
						break;
				}
				//初期化
				switch( Mode ){
					case "Loading":
						Window_PreLoader = new PreLoader( Datas );
						this.addChild( Window_PreLoader );
						break;
					case "Menu":
						this.addChild( Window_MainMenu );
						this.swapChildren( Window_MainMenu , text_FPS );
						break;
					case "City":
						Window_City_Mission.Init( Datas , 0 );
						this.addChild( Window_City_Mission );
						this.swapChildren( Window_City_Mission , text_FPS );
						break;
					case "Garage":
						Window_Garage.Init( Datas, mc_MenuBar );
						this.addChild( Window_Garage );
						this.swapChildren( Window_Garage , text_FPS );
						break;
				}
				OldMode = Mode;
			}
			
			//各モードでの処理
			switch( Mode ){
				case "Loading":
					if( Window_PreLoader.dispLoading() ){
						Mode = "Menu";
					}
					break;
				case "Menu":
					switch( Window_MainMenu.eF() ){
						case 1:
							Mode = "City";
							break;
						case 2:
							Mode = "Garage";
							break;
						default:
							break;
					}
				case "City":
					switch( Window_City_Mission.eF() ){
						case -1:
							Mode = "Menu";
							break;
						default:
							break;
					}
					break;
				case "Garage":
					switch( Window_Garage.eF() ){
						case -1:
							Mode = "Menu";
							break;
						default:
							break;
					}
			}
		}
	}
}