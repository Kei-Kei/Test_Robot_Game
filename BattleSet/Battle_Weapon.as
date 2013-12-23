/*-------------------------------------------------------------------------------------------------
戦闘中の武器の状態を表す
-------------------------------------------------------------------------------------------------*/
package BattleSet{
	
	public class Battle_Weapon{
		public var Category:String;	//武器種別
		public var Ammo:int;		//残り弾数
		public var MagAmmo:int;		//弾倉内最大弾数
		public var Mag:int;			//残り弾倉数
		public var MaxMag:int;		//最大弾倉数
		public var RestAmmo:int;	//残り弾数(控え）
		public var Cycle_Ammo;		//1サイクルで消費する弾数
		public var Time:int;		//リロード中経過時間
		public var Reload_Time;		//リロード時間
		
		public function Battle_Weapon( weapon:Data_Weapon ){
			Category = weapon.Category;
			Ammo = weapon.MagAmmo;
			MagAmmo = weapon.MagAmmo;
			Mag = weapon.MaxMag-1;
			MaxMag = weapon.MaxMag;
			RestAmmo = MagAmmo * Mag;
			Cycle_Ammo = weapon.Cycle_Ammo;
			Time = weapon.Reload_Time;
			Reload_Time = weapon.Reload_Time;
		}
		
		//リロード時間を加算
		public function Reload(){
			if( RestAmmo > 0 ){
				Time++;
				if( Time == Reload_Time ){
					Ammo = MagAmmo;
					RestAmmo -= MagAmmo;
					Mag--;
				}
			}
		}
		
		//射撃処理
		public function Shot(){
			if( Time >= Reload_Time ){
				Ammo -= Cycle_Ammo;
				if( Ammo <= 0 ){
					Time = 0;
				}
			}
		}
		//射撃可能か返す
		public function retReload():Boolean{
			//リロード済みのとき
			if( Time >= Reload_Time ){
				return true;
			//リロード中のとき
			}else{
				return false;
			}
		}
		
		//バーの長さを返す
		public function retBar():Number{
			//リロード済みのときの表示
			if( Time >= Reload_Time ){
				return Ammo / MagAmmo;
			//リロード中のときの表示
			}else{
				return Time / Reload_Time;
			}
		}
		
		//テキスト情報を返す
		public function retText():String{
			//リロード済みのときの表示
			if( Time >= Reload_Time ){
				return Category + ":" + Ammo + "/" + RestAmmo;
			//リロード中のときの表示
			}else{
				if( RestAmmo <= 0 )	return Category + ":ENPTY";
				else				return Category + ":REROAD" + "/" + RestAmmo;
			}
		}
	}
}