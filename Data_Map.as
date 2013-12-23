package{
	import Maps.*;
	
	public class Data_Map{
		public var Tips:Array = new Array();
		public var Walls:Array = new Array();
		
		public function Data_Map(){

		}
		
		//データの構築
		public function Build( newdata:XML ){
			var i:int;
			for( i=0 ; i<newdata.Tip.length() ; i++ ){
				Tips[i] = new Object();
				Tips[i].Pos_X = int(newdata.Tip[i].Pos_X);
				Tips[i].Pos_Y = int(newdata.Tip[i].Pos_Y);
				Tips[i].Skin = int(newdata.Tip[i].Skin);
			}
			for( i=0 ; i<newdata.Wall.length() ; i++){
				Walls[i] = new Wall();
				Walls[i].S_X = int(newdata.Wall[i].S_X);
				Walls[i].S_Y = int(newdata.Wall[i].S_Y);
				Walls[i].G_X = int(newdata.Wall[i].G_X);
				Walls[i].G_Y = int(newdata.Wall[i].G_Y);
				Walls[i].Calc();
			}
		}
	}
}