package{
	public class Data_Enemy{
		
		public var Name:String;
		public var PartsNum:int;
		public var Parts:Array = new Array();
		
		public var MaxHP;
		public var Accel:int;
		public var MaxSpeed:int;
		
		public function Data_Enemy(){
		}
		
		//データの構築
		public function Build( newdata:XML ){
			var i,j:int;
			
			Name = newdata.Name;				//名称
			PartsNum = newdata.Parts.length();	//パーツの数
			for(i=0 ; i<PartsNum ; i++){
				Parts[i] = new Object();
				Parts[i].ID = newdata.Parts[i].ID;			//パーツ番号
				Parts[i].Parent = newdata.Parts[i].Parent;	//パーツの親
				Parts[i].ParentLR = newdata.Parts[i].ParentLR;//接続する親の階層(主に左右区別用)
				Parts[i].Joint = newdata.Parts[i].Joint;	//接続する親のジョイント番号
				Parts[i].Layer = newdata.Parts[i].Layer;	//パーツの表示される階層
				Parts[i].Color = new Array();
				for(j=0 ; j<3 ; j++){
					Parts[i].Color[j] = new Object();
					Parts[i].Color[j].R = newdata.Parts[i].Color[j].R;
					Parts[i].Color[j].G = newdata.Parts[i].Color[j].G;
					Parts[i].Color[j].B = newdata.Parts[i].Color[j].B;
				}
			}
		}
	}
}