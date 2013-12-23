package{
	public class Data_Enemy_Group{
		//敵のAI
		public var AI:Array = new Array();
		
		//敵の出現に関するパラメーター
		public var Start_Time:int;		//敵出現時間（ミリ秒）
		public var Start_Type:int;		//敵出現位置タイプ（自機の近く:0、固定位置:1）
		public var Start_Pos_X:int;		//敵出現位置（自機との相対位置、固定位置）
		public var Start_Pos_Y:int;		//
		public var Start_Dist_X:int;	//出現位置のずれの範囲（出現時にランダム変化）
		public var Start_Dist_Y:int;	//
		public var Regene_Time:int;		//復活までの時間（ミリ秒）
		public var Regene_Count:int;	//復活する回数
		
		//敵の領域に関するパラメーター
		public var Area_Cen_X:int;		//戦闘時行動中心位置（Battle_Type:1のときのみ有効）
		public var Area_Cen_Y:int;		//
		public var Area_S_Range:int;	//索敵範囲
		public var Area_H_Range:int;	//追跡範囲
		public var Area_S_Min_X:int;	//索敵範囲の最小、最大値
		public var Area_S_Max_X:int;
		public var Area_S_Min_Y:int;
		public var Area_S_Max_Y:int;
		public var Area_H_Min_X:int;	//追跡範囲の最小、最大値
		public var Area_H_Max_X:int;
		public var Area_H_Min_Y:int;
		public var Area_H_Max_Y:int;
		
		
		public function Mission_Enemy_Group(){
		}
		
		//初期化
		public function Init( num:int ){
			var i:int;
			for( i=0 ; i<num ; i++ ){
				AI[i] = new Enemy_AI();
			}
		}
		
		//
		public function SetArea(){
			Area_S_Min_X = Area_Cen_X - Area_S_Range;
			Area_S_Max_X = Area_Cen_X + Area_S_Range;
			Area_S_Min_Y = Area_Cen_Y - Area_S_Range;
			Area_S_Max_Y = Area_Cen_Y + Area_S_Range;
			Area_H_Min_X = Area_Cen_X - Area_H_Range;
			Area_H_Max_X = Area_Cen_X + Area_H_Range;
			Area_H_Min_Y = Area_Cen_Y - Area_H_Range;
			Area_H_Max_Y = Area_Cen_Y + Area_H_Range;
		}
		
		//対象が索敵範囲内かどうかを判定
		public function InnerAreaS( pos_x:int , pos_y:int ):Boolean{
			if( pos_x < Area_S_Min_X )	return false;
			if( pos_x > Area_S_Max_X )	return false;
			if( pos_y < Area_S_Min_Y )	return false;
			if( pos_y > Area_S_Max_Y )	return false;
			return true;
		}
		
		//対象が追跡範囲内かどうかを判定
		public function InnerAreaH( pos_x:int , pos_y:int ):Boolean{
			if( pos_x < Area_H_Min_X )	return false;
			if( pos_x > Area_H_Max_X )	return false;
			if( pos_y < Area_H_Min_Y )	return false;
			if( pos_y > Area_H_Max_Y )	return false;
			return true;
		}
	}
}