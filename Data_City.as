package{
	public class Data_City{
		
		public var Missions:Array = new Array;
		
		public function Data_City(){
		}
		
		public function Init(){
		}
		//データの構築
		public function Build( newdata:XML ){
			var i:int,j:int,k:int;
			//都市基本データの読み込み
			
			//ミッションの読み込み
			for( i=0 ; i<newdata.Mission.length() ; i++ ){
				Missions[i] = new Data_City_Mission();
				Missions[i].Num = newdata.Mission[i].Num;
				Missions[i].Exp = newdata.Mission[i].Exp;
			}
		}
	}
}