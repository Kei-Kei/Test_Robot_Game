package{
	public class Data_Mission{
		public var Mis_No:int;					//ミッション番号
		public var Map_No:int;					//戦闘で用いるマップ
		public var Name:String;					//ミッション名
		public var Text:String;					//ミッション説明
		public var My_X:int,My_Y:int;			//自機の開始位置
		public var Rank_TimeOrder:int;			//ランクの時間並び順(昇順:0、降順:1)
		public var Rank_HPOrder:int;			//ランクのＨＰ並び順(昇順:0、降順:1)
		public var Rank:Array = new Array();	//ランク
		public var Targets:Array = new Array;	//ミッションの撃破目標
		public var Groups:Array = new Array();	//敵グループ
		
		public function Data_Mission(){
		}
		
		public function Init(){
			var i:int;
		}
		//データの構築
		public function Build( newdata:XML ){
			var i:int,j:int,k:int;
			//ミッション基本データの読み込み
			Mis_No = newdata.Mission.Mis_No;
			Map_No = newdata.Mission.Map_No;
			Name = newdata.Mission.Name;
			var myPattern:RegExp = /\t/g;
			Text = newdata.Mission.Text;
			Text = Text.replace( myPattern , "" );
			
			//ランクの読み込み
			Rank_TimeOrder = newdata.Mission.Rank_TimeOrder;
			Rank_HPOrder = newdata.Mission.Rank_HPOrder;
			for( i=0 ; i<newdata.Mission.Rank.length() ; i++ ){
				Rank[i] = new Data_Rank();
				Rank[i].Time = newdata.Mission.Rank[i].Time;
				Rank[i].HP = newdata.Mission.Rank[i].HP;
			}
			
			//自機情報の読み込み
			My_X = newdata.Mission.My_X;
			My_Y = newdata.Mission.My_Y;
			
			//グループの読み込み
			for( i=0 ; i<newdata.Mission.Group.length() ; i++ ){
				//ミッション撃破目標を入力
				if( newdata.Mission.Group[i].MissionTarget == 1 ){
					var tar:int = i;
					Targets.push( tar );
				}
				Groups[i] = new Data_Enemy_Group();
				//敵の出現に関するパラメーター
				Groups[i].Start_Time = newdata.Mission.Group[i].Start_Time;		//敵出現時間（ミリ秒）
				Groups[i].Start_Type = newdata.Mission.Group[i].Start_Type;		//敵出現位置タイプ（自機の近く:0、固定位置:1）
				Groups[i].Start_Pos_X = newdata.Mission.Group[i].Start_Pos_X;	//敵出現位置（自機との相対位置、固定位置）
				Groups[i].Start_Pos_Y = newdata.Mission.Group[i].Start_Pos_Y;	//
				Groups[i].Start_Dist_X = newdata.Mission.Group[i].Start_Dist_X;	//出現位置のずれの範囲（出現時にランダム変化）
				Groups[i].Start_Dist_Y = newdata.Mission.Group[i].Start_Dist_Y;	//
				Groups[i].Regene_Time = newdata.Mission.Group[i].Regene_Time;	//復活までの時間（ミリ秒）
				Groups[i].Regene_Count = newdata.Mission.Group[i].Regene_Count;	//出現回数
				
				//敵の領域に関するパラメーター
				Groups[i].Area_Cen_X = newdata.Mission.Group[i].Area_Cen_X;		//戦闘時行動中心位置（Battle_Type:1のときのみ有効）
				Groups[i].Area_Cen_Y = newdata.Mission.Group[i].Area_Cen_Y;		//
				Groups[i].Area_S_Range = newdata.Mission.Group[i].Area_S_Range;	//索敵範囲
				Groups[i].Area_H_Range = newdata.Mission.Group[i].Area_H_Range;	//追跡範囲
				Groups[i].SetArea();											//範囲の最小、最大値を計算しておく
				
				//出現させる敵のデータ
				for( j=0 ; j<newdata.Mission.Group[i].Enemy.length() ; j++ ){
					var ai_num:int;
					ai_num = newdata.Mission.Group[i].Enemy[j];
					Groups[i].AI[j] = new Data_AI();
					Groups[i].AI[j].Type = newdata.AI[ai_num].Type;
					//敵の行動に関するパラメーター
					for( k=0 ; k<newdata.AI[ai_num].B_Type.length() ; k++ ){
						Groups[i].AI[j].B_Type[k] = new Data_AI_Battle();
						Groups[i].AI[j].B_Type[k].Battle_Type = newdata.AI[ai_num].B_Type[k].Battle_Type;	//敵行動タイプ（自機と一定距離を保つ:0、固定領域:1）
						Groups[i].AI[j].B_Type[k].Battle_Cen_X = newdata.AI[ai_num].B_Type[k].Battle_Cen_X;	//戦闘時行動中心位置（Battle_Type:1のときのみ有効）
						Groups[i].AI[j].B_Type[k].Battle_Cen_Y = newdata.AI[ai_num].B_Type[k].Battle_Cen_Y;	//
						Groups[i].AI[j].B_Type[k].Battle_Range = newdata.AI[ai_num].B_Type[k].Battle_Range;	//戦闘時行動半径（Battle_Type:0の場合自機を中心とした距離）
						Groups[i].AI[j].B_Type[k].Battle_Frac = newdata.AI[ai_num].B_Type[k].Battle_Frac;	//戦闘時行動半径のずれ
						Groups[i].AI[j].B_Type[k].Attack_Per = newdata.AI[ai_num].B_Type[k].Attack_Per;		//攻撃頻度
						Groups[i].AI[j].B_Type[k].Pary_Per = newdata.AI[ai_num].B_Type[k].Pary_Per;			//回避頻度
					}
				}
			}
		}
	}
}