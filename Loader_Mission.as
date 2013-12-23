/*-------------------------------------------------------------------------------------------------
ミッションのロード（都市ごとにロードする）
-------------------------------------------------------------------------------------------------*/
package{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	public class Loader_Mission extends Sprite{
		//ファイルローダー
		private var loader_Mission:Array = new Array();
		//ロードするミッション番号キュー
		private var Queue_Mission:Array = new Array();
		
		//スキン
		public var text_Load:MyText = new MyText(200 , 200 , "CENTER");
		
		//ミッションデータ
		private var Missions:Array = new Array();
		
		public function Loader_Mission(){
			this.addChild( text_Load );
		}
		
		//ロードするミッション番号キューの追加
		public function AddQueue( num:int ){
			Queue_Mission[ Queue_Mission.length ] = num;
		}
		
		//ミッション番号キューのリセット
		public function ClearQueue(){
			for( var i:int=0 ; i<Queue_Mission.length ; i++ ){
				Queue_Mission.pop();
			}
		}
		
		//ロード開始
		public function StartLoading( missions:Array ){
			Missions = missions;
			
			//キューに入っている番号のミッションをロードする
			for( var i:int=0 ; i<Queue_Mission.length ; i++ ){
				loader_Mission[i] = new xmlLoader();
				if( Queue_Mission[i] < 10 ){
					loader_Mission[i].Load("data/MissionData/Mission00" + Queue_Mission[i] + ".xml");
				}else if( Queue_Mission[i] < 100 ){
					loader_Mission[i].Load("data/MissionData/Mission0" + Queue_Mission[i] + ".xml");
				}else{
					loader_Mission[i].Load("data/MissionData/Mission" + Queue_Mission[i] + ".xml");
				}
			}
		}
		
		//ロード状況の表示
		public function DispLoading():Boolean{
			//進行状況の表示
			var loadeds,totals:int;
			loadeds = 0;
			totals = 0;
			var completes:Boolean = true;
			for( var i:int=0 ; i<loader_Mission.length ; i++ ){
				//ロード状況の確認
				loadeds += loader_Mission[i].Loaded;
				totals += loader_Mission[i].Total;
				//ロードが完了したかの確認
				if( !loader_Mission[i].Complete ){
					completes = false;
				}
			}
			text_Load.dispText( "Loading:" + loadeds + " bytes / " + totals +" bytes");
			
			//ロードが完了した場合
			if( completes ){
				for( var i:int=0 ; i<loader_Mission.length ; i++ ){
					Missions[i] = new Data_Mission();
					Missions[i].Build( loader_Mission[i].retData() );
				}
				return true;
			}
			return false;
		}
	}
}