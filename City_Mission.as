package{
	import flash.display.Sprite;
	import BattleSet.*;
	
	public class City_Mission extends Sprite{
		//ウィンドウ
		private var Window_IF:City_Mission_IF = new City_Mission_IF();
		private var Window_Loader:Loader_Mission = new Loader_Mission();
		private var Window_Mission:Mission = new Mission();
		
		//タイムライン
		private var Mode:String,OldMode:String;
		
		//データ
		private var Datas:Data_Game = new Data_Game();
		private var Missions:Array = new Array();
		private var Mission_No:int;
		
		//都市の番号
		private var City_Num:int;
		
		public function City_Mission(){
		}
		
		public function Init( datas:Data_Game , num:int ){
			Datas = datas;
			City_Num = num;
			
			Window_Loader.ClearQueue();
			
			Mode = "Loading";
			OldMode = "";
		}
		
		public function eF():int{
			var i:int;
			//モード切替
			if( Mode != OldMode ){
				//後始末
				switch( OldMode ){
					case "Loading":
						this.removeChild( Window_Loader );
						this.removeChild( Window_IF );
						break;
					case "Select":
						this.removeChild( Window_IF );
						break;
					case "Mission":
						this.removeChild( Window_Mission );
						break;
				}
				
				//初期化
				switch( Mode ){
					case "Loading":
						this.addChild( Window_IF );
						Window_IF.Load();
						this.addChild( Window_Loader );
						for( i=0 ; i<Datas.Cities[City_Num].Missions.length ; i++ ){
							Window_Loader.AddQueue( Datas.Cities[City_Num].Missions[i].Num );
						}
						Window_Loader.StartLoading( Missions );
						break;
					case "Select":
						Window_IF.Init( Missions );
						this.addChild( Window_IF );
						break;
					case "Mission":
						Window_Mission.Init( Datas , Missions[Mission_No] );
						this.addChild( Window_Mission );
						break;
				}
				OldMode = Mode;
			}
			
			//毎フレーム処理
			switch( Mode ){
				case "Loading":
					if( Window_Loader.DispLoading() ){
						Mode = "Select";
					}
					break;
				case "Select":
					var mis_no:int;
					mis_no = Window_IF.eF();
					if( mis_no >= 0 ){
						Mission_No = mis_no;
						Mode = "Mission";
					}else if( mis_no == -1 ){
						this.removeChild( Window_IF );
						return -1;
					}
					break;
				case "Mission":
					switch( Window_Mission.eF_Mission() ){
						case -1:
							Mode = "Select";
							break;
					}
					break;
			}
			return 0;
		}
	}
}