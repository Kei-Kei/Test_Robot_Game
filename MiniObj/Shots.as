/*-----------------------------------------------
戦闘時に発射される弾丸の情報を一時的に格納する
-----------------------------------------------*/
package MiniObj{
	public class Shots extends Object{
		public var Bullet_Num:int = 0;
		public var Bullets:Array = new Array();
		public var W_Sound:Data_Weapon_Sound = new Data_Weapon_Sound();
		public function Shots(){}
		
	}
}