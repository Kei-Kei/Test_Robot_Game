/*-----------------------------------------------
戦闘時に発射される弾丸の情報を一時的に格納する
-----------------------------------------------*/
package MiniObj{
	public class Shots_Bullet extends Object{
		public var Type:int;
		public var T_Drec:int;
		public var Drec:int;
		public var Speed:Number;
		public var Pos_X:Number;
		public var Pos_Y:Number;
		public var Target:int;
		public function Shots_Bullet(){}
	}
}