package{
	
	public class Data_Parts{
		
		//属性データ
		public var Name:String;		//名称
		public var Type:String;		//パーツカテゴリ
		public var Skin:int;		//パーツの外観
		public var Dual:Boolean;	//二つでひとつのパーツかどうか？
		//基本データ
		public var Weight:int;		//重量
		public var HP:int;			//HP
		public var EN_Cap:int;		//EN容量
		public var EN_Out:int;		//EN供給
		public var DEF:int;			//防御力
		public var STB:int;			//安定性
		public var LiftW:int;		//リフター荷重性能
		public var LiftM:Number;	//リフター移動性能
		//ブースター
		public var BoostF:int;		//前方推力
		public var BoostB:int;		//後方推力
		public var DashF:int;		//前方ダッシュ時推力
		public var DashB:int;		//後方ダッシュ時推力
		public var Dash_Time:int;	//ダッシュ持続時間
		public var Dash_Charge:int;	//次のダッシュまでのチャージ時間
		public var EN_BoostF:int;	//前方ブースト時消費EN
		public var EN_BoostB:int;	//後方ブースト時消費EN
		public var EN_DashF:int;	//前方ダッシュ時消費EN
		public var EN_DashB:int;	//後方ダッシュ時消費EN
			
		//武装データ
		public var WeaponNum:int;	//武装の数
		public var Weapon:Array = new Array();
		
		public function Data_Parts(){
		}
		
		//データの構築
		public function Build( newdata:XML ){
			var i:int;
			
			//属性データ
			Name = newdata.Name;		//名称
			Type = newdata.Type;		//パーツカテゴリ
			Skin = newdata.Skin;		//パーツの外観
			Dual = Utils.itoB( newdata.Dual );//二つでひとつのパーツかどうか？
			//基本データ
			Weight = newdata.Weight;	//重量
			HP = newdata.HP;			//HP
			EN_Cap = newdata.EN_Cap;	//EN容量
			EN_Out = newdata.EN_Out;	//EN供給
			DEF = newdata.DEF;			//防御力
			STB = newdata.STB;			//安定性
			//リフター
			if( newdata.Lift != null ){
				LiftW = newdata.Lift.LiftW;		//リフター荷重性能
				LiftM = newdata.Lift.LiftM;		//リフター移動性能
			}else{
				LiftW = 0;						//リフター荷重性能
				LiftM = 0;						//リフター移動性能
			}
			//ブースト
			if( newdata.Boost != null ){
				BoostF = newdata.Boost.BoostF;			//前方推力
				BoostB = newdata.Boost.BoostB;			//後方推力
				DashF = newdata.Boost.DashF;			//前方ダッシュ時推力
				DashB = newdata.Boost.DashB;			//後方ダッシュ時推力
				Dash_Time = newdata.Boost.Dash_Time;	//ダッシュ持続時間
				Dash_Charge = newdata.Boost.Dash_Charge;//次のダッシュまでのチャージ時間
				EN_BoostF = newdata.Boost.EN_BoostF;	//前方ブースト時消費EN
				EN_BoostB = newdata.Boost.EN_BoostB;	//後方ブースト時消費EN
				EN_DashF = newdata.Boost.EN_DashF;		//前方ダッシュ時消費EN
				EN_DashB = newdata.Boost.EN_DashB;		//後方ダッシュ時消費EN
			}else{
				BoostF = 0;						//前方推力
				BoostB = 0;						//後方推力
				DashF = 0;						//前方ダッシュ時推力
				DashB = 0;						//後方ダッシュ時推力
				Dash_Time = 0;					//ダッシュ持続時間
				Dash_Charge = 0;				//次のダッシュまでのチャージ時間
				EN_BoostF = 0;					//前方ブースト時消費EN
				EN_BoostB = 0;					//後方ブースト時消費EN
				EN_DashF = 0;					//前方ダッシュ時消費EN
				EN_DashB = 0;					//後方ダッシュ時消費EN
			}
			//武装データ
			WeaponNum = newdata.Weapon.length();	//武装の数
			for(i=0 ; i<WeaponNum ; i++){
				Weapon[i] = new Object();
				Weapon[i].WepNum = newdata.Weapon[i].WepNum;	//パーツに割り当てる武装
				Weapon[i].WepSkin = newdata.Weapon[i].WepSkin;	//スキンのどの部位に武装を割り当てるか
			}
		}
		
	}
}