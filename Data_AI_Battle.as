package{
	public class Data_AI_Battle extends Object{
		//敵の行動に関するパラメーター
		public var Battle_Type:int;		//行動タイプ（ターゲットと一定距離を保つ:0、固定領域:1）
		public var Battle_Cen_X:int;	//戦闘時行動中心位置（Battle_Type:1のときのみ有効）
		public var Battle_Cen_Y:int;	//
		public var Battle_Range:int;	//戦闘時行動半径（Battle_Type:0の場合ターゲットを中心とした距離）
		public var Battle_Frac:int;		//戦闘時行動半径のずれ
		public var Attack_Per:Number;	//攻撃頻度
		public var Pary_Per:Number;		//回避頻度
	}
}